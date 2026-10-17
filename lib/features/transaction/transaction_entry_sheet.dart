import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runway_finance/core/constants/strings.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/core/utils/date_helper.dart';
import 'package:runway_finance/core/utils/id_generator.dart';
import 'package:runway_finance/core/utils/money_formatter.dart';
import 'package:runway_finance/data/database/app_database.dart';
import 'package:runway_finance/domain/entities/envelope_entity.dart';
import 'package:runway_finance/domain/entities/transaction_entity.dart';
import 'package:runway_finance/domain/sweat_calculator.dart';
import 'package:runway_finance/providers/repository_providers.dart';
import 'package:runway_finance/providers/runway_provider.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_button.dart';

class TransactionEntrySheet extends ConsumerStatefulWidget {
  const TransactionEntrySheet({super.key});

  @override
  ConsumerState<TransactionEntrySheet> createState() => _TransactionEntrySheetState();
}

class _TransactionEntrySheetState extends ConsumerState<TransactionEntrySheet> {
  String _selectedSegment = 'KELUAR'; // MASUK, KELUAR, DI JALAN
  String _rawAmount = '0';
  String? _selectedEnvelopeId;
  String _incomeDestinationId = 'unassigned'; // 'unassigned', 'buffer', or envelope ID
  final TextEditingController _clientController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _clientController.dispose();
    super.dispose();
  }

  void _pressKey(String key) {
    HapticFeedback.lightImpact();
    setState(() {
      if (key == 'delete') {
        if (_rawAmount.length <= 1) {
          _rawAmount = '0';
        } else {
          _rawAmount = _rawAmount.substring(0, _rawAmount.length - 1);
        }
        return;
      }

      if (_rawAmount == '0') {
        _rawAmount = key;
      } else {
        _rawAmount = '$_rawAmount$key';
      }

      // Bersihkan leading zero jika ada
      _rawAmount = _rawAmount.replaceFirst(RegExp(r'^0+'), '');
      if (_rawAmount.isEmpty) _rawAmount = '0';
    });
  }

  Future<void> _handleSave() async {
    final amount = int.tryParse(_rawAmount) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.errorEmptyAmount)),
      );
      return;
    }

    final envelopeRepo = ref.read(envelopeRepositoryProvider);
    final transactionRepo = ref.read(transactionRepositoryProvider);
    final bufferDao = ref.read(bufferDaoProvider);
    final now = DateTime.now();
    final localDate = DateHelper.todayLocalDateString();

    // 1. KELUAR (Pengeluaran)
    if (_selectedSegment == 'KELUAR') {
      final envelopes = await envelopeRepo.getActiveEnvelopes();
      final userEnvelopes = envelopes.where((e) => !e.isSystem).toList();

      final targetEnvId = _selectedEnvelopeId ?? (userEnvelopes.isNotEmpty ? userEnvelopes.first.id : 'unassigned');
      final targetEnv = envelopes.firstWhere(
        (e) => e.id == targetEnvId,
        orElse: () => envelopes.first,
      );

      // Kalkulator Keringat jika pengeluaran Wants
      if (targetEnv.category == EnvelopeCategory.wants) {
        final runwayState = ref.read(runwayProvider).asData?.value;
        final avgDailySpend = runwayState?.avgDailySpend;

        final costInDays = SweatCalculator.calculateCostInDays(
          amount: amount,
          avgDailySpend: avgDailySpend,
        );

        if (SweatCalculator.shouldShowPrompt(costInDays) && mounted) {
          final shouldProceed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: BrutalTokens.canvas,
              shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
              title: const Text(
                AppStrings.sweatCalculatorTitle,
                style: TextStyle(
                  fontFamily: BrutalTokens.fontUi,
                  fontWeight: FontWeight.w900,
                  color: BrutalTokens.ink,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Peringatan! Beli ini akan mengorbankan $costInDays hari daya tahan hidupmu.',
                    style: const TextStyle(
                      fontFamily: BrutalTokens.fontUi,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: BrutalTokens.ink,
                    ),
                  ),
                  const SizedBox(height: BrutalTokens.spaceMd),
                  const Text(
                    AppStrings.sweatDecisionQuestion,
                    style: TextStyle(
                      fontFamily: BrutalTokens.fontUi,
                      fontSize: 14,
                      color: BrutalTokens.muted,
                    ),
                  ),
                ],
              ),
              actions: [
                BrutalButton(
                  text: AppStrings.sweatResist,
                  variant: BrutalButtonVariant.safe,
                  onPressed: () => Navigator.of(ctx).pop(false),
                ),
                BrutalButton(
                  text: AppStrings.sweatProceed,
                  variant: BrutalButtonVariant.danger,
                  onPressed: () => Navigator.of(ctx).pop(true),
                ),
              ],
            ),
          );

          if (shouldProceed != true) {
            // Pengguna memilih TAHAN DIRI: catat ke resisted_events!
            await transactionRepo.recordResistedEvent(
              id: IdGenerator.nextId(),
              amount: amount,
              occurredAt: now,
              localDate: localDate,
            );

            if (mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: BrutalTokens.safe,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
                  content: Text(
                    '🔥 HEBAT! Kamu menahan diri. Puasa jajan berlanjut!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: BrutalTokens.fontUi,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: BrutalTokens.ink,
                    ),
                  ),
                ),
              );
            }
            return;
          }
        }
      }

      setState(() => _isLoading = true);
      try {
        await transactionRepo.recordTransaction(
          id: IdGenerator.nextId(),
          type: TransactionType.expense,
          amount: amount,
          occurredAt: now,
          localDate: localDate,
          fromEnvelopeId: targetEnvId,
          countsAsSpending: true,
        );

        _onSuccess('✓ PENGELUARAN TERCATAT');
      } catch (e) {
        _onError(e);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
      return;
    }

    // 2. MASUK (Pemasukan)
    if (_selectedSegment == 'MASUK') {
      setState(() => _isLoading = true);
      try {
        if (_incomeDestinationId == 'buffer') {
          // Masuk ke Bantalan Bulan Depan: simpan transaksi & buffer entry
          final bufferEntryId = IdGenerator.nextId();
          final txId = IdGenerator.nextId();
          final nextMonthDate = now.add(const Duration(days: 32));
          final releaseMonth = DateHelper.toReleaseMonthString(nextMonthDate);

          await transactionRepo.recordTransaction(
            id: txId,
            type: TransactionType.income,
            amount: amount,
            occurredAt: now,
            localDate: localDate,
            toEnvelopeId: 'buffer',
            bufferEntryId: bufferEntryId,
            note: 'Pemasukan Bantalan Bulan Depan',
          );

          await bufferDao.insertBufferEntry(
            BufferEntriesTableCompanion.insert(
              id: bufferEntryId,
              amount: amount,
              releaseMonth: releaseMonth,
              holdTransactionId: txId,
              createdAt: now.toUtc(),
            ),
          );
        } else {
          // Masuk ke Belum Dialokasikan atau amplop tertentu
          await transactionRepo.recordTransaction(
            id: IdGenerator.nextId(),
            type: TransactionType.income,
            amount: amount,
            occurredAt: now,
            localDate: localDate,
            toEnvelopeId: _incomeDestinationId,
            note: _incomeDestinationId == 'unassigned' ? 'Pemasukan Kas' : 'Pemasukan Pos',
          );
        }

        _onSuccess('✓ PEMASUKAN TERCATAT');
      } catch (e) {
        _onError(e);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
      return;
    }

    // 3. DI JALAN (Uang di jalan / Piutang / Invoice menunggu cair)
    if (_selectedSegment == 'DI JALAN') {
      setState(() => _isLoading = true);
      try {
        final clientName = _clientController.text.trim().isEmpty
            ? 'Uang di jalan'
            : _clientController.text.trim();

        await transactionRepo.recordPendingIncome(
          id: IdGenerator.nextId(),
          amount: amount,
          client: clientName,
        );

        _onSuccess('✓ UANG DI JALAN TERCATAT');
      } catch (e) {
        _onError(e);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
      return;
    }
  }

  void _onSuccess(String message) {
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: BrutalTokens.safe,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: BrutalTokens.fontUi,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: BrutalTokens.ink,
              letterSpacing: 0.8,
            ),
          ),
        ),
      );
    }
  }

  void _onError(Object e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final envelopeRepo = ref.watch(envelopeRepositoryProvider);
    final formattedAmount = MoneyFormatter.formatWithoutSymbol(int.tryParse(_rawAmount) ?? 0);

    Color amountBg = BrutalTokens.danger;
    if (_selectedSegment == 'MASUK') amountBg = BrutalTokens.safe;
    if (_selectedSegment == 'DI JALAN') amountBg = BrutalTokens.warn;

    const numpadKeys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '000', '0', 'delete'];

    return Container(
      decoration: const BoxDecoration(
        color: BrutalTokens.canvas,
        border: Border(
          top: BorderSide(color: BrutalTokens.ink, width: BrutalTokens.borderHeavy),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet Head
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CATAT GERAK UANG',
                        style: TextStyle(
                          fontFamily: BrutalTokens.fontUi,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: BrutalTokens.ink,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Transaksi baru',
                        style: TextStyle(
                          fontFamily: BrutalTokens.fontUi,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: BrutalTokens.ink,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: BrutalTokens.paper,
                        border: Border.all(
                          color: BrutalTokens.ink,
                          width: BrutalTokens.borderBase,
                        ),
                        boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                      ),
                      child: const Icon(Icons.close, color: BrutalTokens.ink, size: 24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Segmented Buttons (MASUK, KELUAR, DI JALAN)
              Row(
                children: ['MASUK', 'KELUAR', 'DI JALAN'].map((seg) {
                  final isActive = _selectedSegment == seg;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedSegment = seg),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: isActive ? BrutalTokens.warn : BrutalTokens.paper,
                          border: Border.all(
                            color: BrutalTokens.ink,
                            width: BrutalTokens.borderThin,
                          ),
                          boxShadow: isActive
                              ? const [
                                  BoxShadow(
                                    color: BrutalTokens.ink,
                                    offset: Offset(0, 4),
                                    blurRadius: 0,
                                  ),
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          seg,
                          style: const TextStyle(
                            fontFamily: BrutalTokens.fontUi,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: BrutalTokens.ink,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Amount Panel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: amountBg,
                  borderRadius: BrutalTokens.radiusZero,
                  border: Border.all(
                    color: BrutalTokens.ink,
                    width: BrutalTokens.borderHeavy,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _selectedSegment == 'DI JALAN'
                          ? 'NOMINAL UANG DI JALAN'
                          : (_selectedSegment == 'MASUK' ? 'NOMINAL MASUK' : 'NOMINAL KELUAR'),
                      style: const TextStyle(
                        fontFamily: BrutalTokens.fontUi,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: BrutalTokens.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          'Rp ',
                          style: TextStyle(
                            fontFamily: BrutalTokens.fontUi,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: BrutalTokens.ink,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            formattedAmount,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontNumbers,
                              fontSize: 37,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.0,
                              color: BrutalTokens.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 1. Selector jika KELUAR: Pakai amplop mana?
              if (_selectedSegment == 'KELUAR') ...[
                const Text(
                  'PAKAI AMPLOP',
                  style: TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: BrutalTokens.ink,
                  ),
                ),
                const SizedBox(height: 8),
                StreamBuilder<List<EnvelopeEntity>>(
                  stream: envelopeRepo.watchActiveEnvelopes(),
                  builder: (context, snapshot) {
                    final allEnvelopes = snapshot.data ?? [];
                    final userEnvelopes = allEnvelopes.where((e) => !e.isSystem).toList();

                    if (userEnvelopes.isEmpty) return const SizedBox.shrink();
                    _selectedEnvelopeId ??= userEnvelopes.first.id;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: userEnvelopes.map((env) {
                          final isSelected = env.id == _selectedEnvelopeId;
                          final isNeeds = env.category == EnvelopeCategory.needs;
                          final activeColor = isNeeds ? BrutalTokens.needs : BrutalTokens.wants;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedEnvelopeId = env.id),
                            child: Container(
                              height: 38,
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: isSelected ? activeColor : BrutalTokens.paper,
                                borderRadius: BrutalTokens.radiusZero,
                                border: Border.all(
                                  color: BrutalTokens.ink,
                                  width: BrutalTokens.borderThin,
                                ),
                                boxShadow: isSelected
                                    ? BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm)
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${env.icon ?? ''} ${env.name}',
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
              ],

              // 2. Selector jika MASUK: Alokasi ke mana?
              if (_selectedSegment == 'MASUK') ...[
                const Text(
                  'TUJUAN ALOKASI MASUK',
                  style: TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: BrutalTokens.ink,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Belum Dialokasikan (Default)
                      GestureDetector(
                        onTap: () => setState(() => _incomeDestinationId = 'unassigned'),
                        child: Container(
                          height: 38,
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: _incomeDestinationId == 'unassigned'
                                ? BrutalTokens.warn
                                : BrutalTokens.paper,
                            borderRadius: BrutalTokens.radiusZero,
                            border: Border.all(
                              color: BrutalTokens.ink,
                              width: BrutalTokens.borderThin,
                            ),
                            boxShadow: _incomeDestinationId == 'unassigned'
                                ? BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm)
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '💼 Belum Dialokasikan',
                            style: TextStyle(
                              fontFamily: BrutalTokens.fontUi,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: BrutalTokens.ink,
                            ),
                          ),
                        ),
                      ),
                      // Bantalan Bulan Depan
                      GestureDetector(
                        onTap: () => setState(() => _incomeDestinationId = 'buffer'),
                        child: Container(
                          height: 38,
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: _incomeDestinationId == 'buffer'
                                ? BrutalTokens.buffer
                                : BrutalTokens.paper,
                            borderRadius: BrutalTokens.radiusZero,
                            border: Border.all(
                              color: BrutalTokens.ink,
                              width: BrutalTokens.borderThin,
                            ),
                            boxShadow: _incomeDestinationId == 'buffer'
                                ? BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm)
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '🛡️ Bantalan Bln Depan',
                            style: TextStyle(
                              fontFamily: BrutalTokens.fontUi,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: BrutalTokens.ink,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // 3. Input jika DI JALAN: Klien / Keterangan
              if (_selectedSegment == 'DI JALAN') ...[
                const Text(
                  'KETERANGAN / DARI SIAPA?',
                  style: TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: BrutalTokens.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: BrutalTokens.paper,
                    border: Border.all(
                      color: BrutalTokens.ink,
                      width: BrutalTokens.borderBase,
                    ),
                    boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                  ),
                  child: TextField(
                    controller: _clientController,
                    style: const TextStyle(
                      fontFamily: BrutalTokens.fontUi,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: BrutalTokens.ink,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Contoh: Invoice Klien Web, Gaji, dll.',
                      hintStyle: TextStyle(
                        fontFamily: BrutalTokens.fontUi,
                        fontSize: 13,
                        color: BrutalTokens.muted,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Physical Numpad 3x4
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 7,
                  mainAxisSpacing: 7,
                  childAspectRatio: 2.1,
                ),
                itemCount: numpadKeys.length,
                itemBuilder: (context, index) {
                  final k = numpadKeys[index];
                  return GestureDetector(
                    onTap: () => _pressKey(k),
                    child: Container(
                      decoration: BoxDecoration(
                        color: BrutalTokens.paper,
                        borderRadius: BrutalTokens.radiusZero,
                        border: Border.all(
                          color: BrutalTokens.ink,
                          width: BrutalTokens.borderThin,
                        ),
                        boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                      ),
                      alignment: Alignment.center,
                      child: k == 'delete'
                          ? const Icon(Icons.backspace_outlined, size: 22, color: BrutalTokens.ink)
                          : Text(
                              k,
                              style: const TextStyle(
                                fontFamily: BrutalTokens.fontNumbers,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: BrutalTokens.ink,
                              ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // Save Button
              BrutalButton(
                text: _isLoading
                    ? 'MENYIMPAN...'
                    : (_selectedSegment == 'MASUK'
                        ? 'SIMPAN PEMASUKAN'
                        : (_selectedSegment == 'DI JALAN' ? 'CATAT UANG DI JALAN' : 'SIMPAN PENGELUARAN')),
                variant: BrutalButtonVariant.primary,
                isFullWidth: true,
                icon: const Icon(Icons.arrow_forward, size: 20, color: BrutalTokens.ink),
                onPressed: _isLoading ? null : _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
