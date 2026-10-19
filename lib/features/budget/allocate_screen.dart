import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/core/utils/date_helper.dart';
import 'package:runway_finance/core/utils/id_generator.dart';
import 'package:runway_finance/core/utils/money_formatter.dart';
import 'package:runway_finance/domain/entities/envelope_entity.dart';
import 'package:runway_finance/domain/entities/transaction_entity.dart';
import 'package:runway_finance/providers/repository_providers.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_button.dart';
import 'package:runway_finance/shared/widgets/brutal/page_headers.dart';
import 'package:runway_finance/shared/widgets/brutal/stamp.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_toast.dart';

class AllocateScreen extends ConsumerStatefulWidget {
  final String? initialEnvelopeId;

  const AllocateScreen({
    super.key,
    this.initialEnvelopeId,
  });

  @override
  ConsumerState<AllocateScreen> createState() => _AllocateScreenState();
}

class _AllocateScreenState extends ConsumerState<AllocateScreen> {
  String _selectedFilter = 'all'; // all, needs, wants
  bool _hasOpenedInitialDialog = false;

  @override
  Widget build(BuildContext context) {
    final envelopeRepo = ref.watch(envelopeRepositoryProvider);

    return Scaffold(
      backgroundColor: BrutalTokens.canvas,
      body: SafeArea(
        child: StreamBuilder<int>(
          stream: envelopeRepo.watchEnvelopeBalance('unassigned'),
          builder: (context, unassignedSnap) {
            final unassignedBalance = unassignedSnap.data ?? 0;

            return StreamBuilder<List<EnvelopeEntity>>(
              stream: envelopeRepo.watchActiveEnvelopes(),
              builder: (context, snapshot) {
                final allEnvelopes = snapshot.data ?? [];
                final userEnvelopes = allEnvelopes.where((e) => !e.isSystem).toList();

                // Buka dialog awal jika ada query parameter initialEnvelopeId
                if (!_hasOpenedInitialDialog && widget.initialEnvelopeId != null && userEnvelopes.isNotEmpty) {
                  final target = userEnvelopes.where((e) => e.id == widget.initialEnvelopeId).toList();
                  if (target.isNotEmpty) {
                    _hasOpenedInitialDialog = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      final targetBal = await envelopeRepo.getEnvelopeBalance(target.first.id);
                      if (mounted) {
                        _showAllocateDialog(
                          this.context,
                          target.first,
                          targetBal,
                          unassignedBalance,
                          userEnvelopes,
                        );
                      }
                    });
                  }
                }

                final filtered = _selectedFilter == 'all'
                    ? userEnvelopes
                    : userEnvelopes.where((e) {
                        if (_selectedFilter == 'needs') {
                          return e.category == EnvelopeCategory.needs;
                        } else {
                          return e.category == EnvelopeCategory.wants;
                        }
                      }).toList();

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
                  children: [
                    DetailHeader(
                      eyebrow: 'BAGI TUGAS SETIAP RUPIAH',
                      title: 'Atur alokasi',
                      onBack: () => context.pop(),
                    ),

                    // 1. Hero Card: Kas Belum Dialokasikan
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: unassignedBalance > 0
                            ? BrutalTokens.warn
                            : unassignedBalance == 0
                                ? const Color(0xFFD4EDDA)
                                : BrutalTokens.danger,
                        borderRadius: BrutalTokens.radiusZero,
                        border: Border.all(
                          color: BrutalTokens.ink,
                          width: BrutalTokens.borderHeavy,
                        ),
                        boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowLg),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'KAS BELUM DIALOKASIKAN',
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                              Stamp(
                                text: unassignedBalance > 0
                                    ? 'PERLU DIBAGI'
                                    : unassignedBalance == 0
                                        ? '● ZERO-BASED'
                                        : 'DEFISIT',
                                backgroundColor: BrutalTokens.paper,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            MoneyFormatter.format(unassignedBalance),
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontNumbers,
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                              color: BrutalTokens.ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            unassignedBalance > 0
                                ? 'Pilih pos amplop di bawah untuk memberi tugas setiap rupiah kas ini.'
                                : unassignedBalance == 0
                                    ? 'Sempurna! Semua rupiah sudah dialokasikan ke posnya masing-masing.'
                                    : 'Perhatian: Alokasi melebihi kas masuk. Tarik sebagian saldo pos.',
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontUi,
                              fontSize: 12,
                              color: BrutalTokens.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 2. Action Strip: Filter & Tombol Kelola Pos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'POS AMPLOP (${filtered.length})',
                          style: const TextStyle(
                            fontFamily: BrutalTokens.fontUi,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                            color: BrutalTokens.ink,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/envelopes'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: BrutalTokens.paper,
                              borderRadius: BrutalTokens.radiusZero,
                              border: Border.all(
                                color: BrutalTokens.ink,
                                width: BrutalTokens.borderThin,
                              ),
                              boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.settings_outlined, size: 14, color: BrutalTokens.ink),
                                SizedBox(width: 4),
                                Text(
                                  'KELOLA POS',
                                  style: TextStyle(
                                    fontFamily: BrutalTokens.fontUi,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Filter Tabs
                    Row(
                      children: [
                        _buildFilterTab('all', 'SEMUA'),
                        _buildFilterTab('needs', 'KEBUTUHAN'),
                        _buildFilterTab('wants', 'KEINGINAN'),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Empty State
                    if (filtered.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: BrutalTokens.paper,
                          border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Tidak ada amplop di kategori ini. Tambahkan pos baru di Kelola Pos.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w700),
                        ),
                      ),

                    // 3. Daftar Amplop Interaktif (Dapat Ditekan)
                    ...filtered.map((item) {
                      final isNeeds = item.category == EnvelopeCategory.needs;
                      final iconDisplay = item.icon ?? (isNeeds ? '🍽️' : '🍿');

                      return StreamBuilder<int>(
                        stream: envelopeRepo.watchEnvelopeBalance(item.id),
                        builder: (context, balSnap) {
                          final balance = balSnap.data ?? 0;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: isNeeds ? BrutalTokens.needs : BrutalTokens.wants,
                              borderRadius: BrutalTokens.radiusZero,
                              border: Border.all(
                                color: BrutalTokens.ink,
                                width: BrutalTokens.borderBase,
                              ),
                              boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _showAllocateDialog(
                                  context,
                                  item,
                                  balance,
                                  unassignedBalance,
                                  userEnvelopes,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          // Icon Box
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: BrutalTokens.paper,
                                              border: Border.all(
                                                color: BrutalTokens.ink,
                                                width: BrutalTokens.borderThin,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              iconDisplay,
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                          ),
                                          const SizedBox(width: 12),

                                          // Info Name & Category
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.name,
                                                  style: const TextStyle(
                                                    fontFamily: BrutalTokens.fontUi,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w900,
                                                    color: BrutalTokens.ink,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  isNeeds ? 'KEBUTUHAN' : 'KEINGINAN',
                                                  style: TextStyle(
                                                    fontFamily: BrutalTokens.fontUi,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w800,
                                                    color: isNeeds ? const Color(0xFF2E6318) : const Color(0xFF944F00),
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Saldo Saat Ini
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'SALDO POS',
                                                style: TextStyle(
                                                  fontFamily: BrutalTokens.fontUi,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w800,
                                                  color: BrutalTokens.muted,
                                                ),
                                              ),
                                              Text(
                                                MoneyFormatter.format(balance),
                                                style: const TextStyle(
                                                  fontFamily: BrutalTokens.fontNumbers,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w900,
                                                  color: BrutalTokens.ink,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      // Tombol Aksi Langsung Pada Kartu
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () => _showAllocateDialog(
                                                context,
                                                item,
                                                balance,
                                                unassignedBalance,
                                                userEnvelopes,
                                                initialMode: 'deposit',
                                              ),
                                              child: Container(
                                                height: 38,
                                                decoration: BoxDecoration(
                                                  color: BrutalTokens.paper,
                                                  borderRadius: BrutalTokens.radiusZero,
                                                  border: Border.all(
                                                    color: BrutalTokens.ink,
                                                    width: BrutalTokens.borderThin,
                                                  ),
                                                  boxShadow: BrutalTokens.hardShadow(offset: 2),
                                                ),
                                                alignment: Alignment.center,
                                                child: const Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.add, size: 16, color: BrutalTokens.ink),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'ISI SALDO',
                                                      style: TextStyle(
                                                        fontFamily: BrutalTokens.fontUi,
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w900,
                                                        letterSpacing: 0.5,
                                                        color: BrutalTokens.ink,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (balance > 0) ...[
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () => _showAllocateDialog(
                                                context,
                                                item,
                                                balance,
                                                unassignedBalance,
                                                userEnvelopes,
                                                initialMode: 'withdraw',
                                              ),
                                              child: Container(
                                                height: 38,
                                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                                decoration: BoxDecoration(
                                                  color: BrutalTokens.paper,
                                                  borderRadius: BrutalTokens.radiusZero,
                                                  border: Border.all(
                                                    color: BrutalTokens.ink,
                                                    width: BrutalTokens.borderThin,
                                                  ),
                                                  boxShadow: BrutalTokens.hardShadow(offset: 2),
                                                ),
                                                alignment: Alignment.center,
                                                child: const Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.arrow_upward, size: 14, color: BrutalTokens.ink),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'TARIK',
                                                      style: TextStyle(
                                                        fontFamily: BrutalTokens.fontUi,
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w900,
                                                        letterSpacing: 0.5,
                                                        color: BrutalTokens.ink,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 40),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // =========================================================================
  // DIALOG ALOKASI DANA KE / DARI AMPLOP
  // =========================================================================
  void _showAllocateDialog(
    BuildContext context,
    EnvelopeEntity envelope,
    int envelopeBalance,
    int unassignedBalance,
    List<EnvelopeEntity> allEnvelopes, {
    String initialMode = 'deposit', // deposit, withdraw, transfer
  }) {
    final amountCtrl = TextEditingController();
    final txRepo = ref.read(transactionRepositoryProvider);
    String mode = initialMode;
    String? destinationEnvelopeId = allEnvelopes.where((e) => e.id != envelope.id).isNotEmpty
        ? allEnvelopes.where((e) => e.id != envelope.id).first.id
        : null;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            backgroundColor: BrutalTokens.canvas,
            shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
            title: Row(
              children: [
                Text(envelope.icon ?? '📁', style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    envelope.name.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: BrutalTokens.fontUi,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Bar Saldo
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: BrutalTokens.paper,
                      border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Saldo Pos Saat Ini:',
                              style: TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              MoneyFormatter.format(envelopeBalance),
                              style: const TextStyle(fontFamily: BrutalTokens.fontNumbers, fontSize: 13, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        const Divider(height: 10, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Kas Belum Dialokasikan:',
                              style: TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              MoneyFormatter.format(unassignedBalance),
                              style: const TextStyle(
                                fontFamily: BrutalTokens.fontNumbers,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: BrutalTokens.ink,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Mode Switcher (ISI DARI KAS / TARIK KE KAS / PINDAH POS)
                  const Text(
                    'Pilih Aksi:',
                    style: TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildModeButton(
                        'deposit',
                        'ISI POS',
                        mode == 'deposit',
                        () => setDialogState(() => mode = 'deposit'),
                      ),
                      if (envelopeBalance > 0) ...[
                        const SizedBox(width: 4),
                        _buildModeButton(
                          'withdraw',
                          'TARIK',
                          mode == 'withdraw',
                          () => setDialogState(() => mode = 'withdraw'),
                        ),
                        if (allEnvelopes.where((e) => e.id != envelope.id).isNotEmpty) ...[
                          const SizedBox(width: 4),
                          _buildModeButton(
                            'transfer',
                            'PINDAH',
                            mode == 'transfer',
                            () => setDialogState(() => mode = 'transfer'),
                          ),
                        ],
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Jika mode transfer antar pos, tampilkan dropdown tujuan
                  if (mode == 'transfer') ...[
                    const Text(
                      'Pindah ke Pos Tujuan:',
                      style: TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 11, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: BrutalTokens.paper,
                        border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: destinationEnvelopeId,
                          isExpanded: true,
                          items: allEnvelopes.where((e) => e.id != envelope.id).map((other) {
                            return DropdownMenuItem<String>(
                              value: other.id,
                              child: Text(
                                '${other.icon ?? "📁"} ${other.name}',
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => destinationEnvelopeId = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Input Nominal
                  TextField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: mode == 'deposit'
                          ? 'Nominal Alokasi (Rp)'
                          : mode == 'withdraw'
                              ? 'Nominal Tarik ke Kas (Rp)'
                              : 'Nominal Pindah Pos (Rp)',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Quick Chips Sesuai Mode
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (mode == 'deposit') ...[
                        _quickChip('50rb', 50000, amountCtrl),
                        _quickChip('100rb', 100000, amountCtrl),
                        _quickChip('250rb', 250000, amountCtrl),
                        _quickChip('500rb', 500000, amountCtrl),
                        if (unassignedBalance > 0)
                          _quickChip('Semua Kas', unassignedBalance, amountCtrl),
                      ] else ...[
                        _quickChip('25%', (envelopeBalance * 0.25).toInt(), amountCtrl),
                        _quickChip('50%', (envelopeBalance * 0.50).toInt(), amountCtrl),
                        _quickChip('Semua Pos', envelopeBalance, amountCtrl),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              BrutalButton(
                text: 'BATAL',
                variant: BrutalButtonVariant.neutral,
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              BrutalButton(
                text: mode == 'deposit'
                    ? 'ALOKASIKAN'
                    : mode == 'withdraw'
                        ? 'TARIK KE KAS'
                        : 'PINDAHKAN',
                variant: BrutalButtonVariant.primary,
                onPressed: () async {
                  final amount = int.tryParse(amountCtrl.text.replaceAll('.', '').trim()) ?? 0;
                  if (amount <= 0) return;

                  final now = DateTime.now();
                  final localDate = DateHelper.todayLocalDateString();

                  if (mode == 'deposit') {
                    // Kas Belum Dialokasikan -> Pos
                    await txRepo.recordTransaction(
                      id: IdGenerator.nextId(),
                      type: TransactionType.allocation,
                      amount: amount,
                      occurredAt: now,
                      localDate: localDate,
                      fromEnvelopeId: 'unassigned',
                      toEnvelopeId: envelope.id,
                      note: 'Alokasi ke pos: ${envelope.name}',
                    );
                    if (ctx.mounted) {
                      Navigator.of(ctx).pop();
                      BrutalToast.showSuccess(
                        context,
                        title: 'ALOKASI POS BERHASIL',
                        message: 'Rp ${MoneyFormatter.formatWithoutSymbol(amount)} dialokasikan ke pos "${envelope.name}".',
                        pushToSystem: true,
                      );
                    }
                  } else if (mode == 'withdraw') {
                    // Pos -> Kas Belum Dialokasikan
                    if (amount > envelopeBalance) {
                      BrutalToast.showError(
                        context,
                        title: 'NOMINAL MELEBIHI SALDO POS',
                        message: 'Saldo pos "${envelope.name}" hanya Rp ${MoneyFormatter.formatWithoutSymbol(envelopeBalance)}.',
                        pushToSystem: true,
                      );
                      return;
                    }

                    await txRepo.recordTransaction(
                      id: IdGenerator.nextId(),
                      type: TransactionType.allocation,
                      amount: amount,
                      occurredAt: now,
                      localDate: localDate,
                      fromEnvelopeId: envelope.id,
                      toEnvelopeId: 'unassigned',
                      note: 'Tarik dari pos: ${envelope.name} ke kas',
                    );
                    if (ctx.mounted) {
                      Navigator.of(ctx).pop();
                      BrutalToast.showSuccess(
                        context,
                        title: 'PENARIKAN KE KAS BERHASIL',
                        message: 'Rp ${MoneyFormatter.formatWithoutSymbol(amount)} dikembalikan dari "${envelope.name}" ke Kas Bebas.',
                        pushToSystem: true,
                      );
                    }
                  } else if (mode == 'transfer' && destinationEnvelopeId != null) {
                    // Pos A -> Pos B
                    if (amount > envelopeBalance) {
                      BrutalToast.showError(
                        context,
                        title: 'NOMINAL MELEBIHI SALDO POS',
                        message: 'Saldo pos "${envelope.name}" hanya Rp ${MoneyFormatter.formatWithoutSymbol(envelopeBalance)}.',
                        pushToSystem: true,
                      );
                      return;
                    }

                    final destEnvelope = allEnvelopes.firstWhere((e) => e.id == destinationEnvelopeId);
                    await txRepo.recordTransaction(
                      id: IdGenerator.nextId(),
                      type: TransactionType.transfer,
                      amount: amount,
                      occurredAt: now,
                      localDate: localDate,
                      fromEnvelopeId: envelope.id,
                      toEnvelopeId: destinationEnvelopeId,
                      note: 'Pindah pos dari ${envelope.name} ke ${destEnvelope.name}',
                    );
                    if (ctx.mounted) {
                      Navigator.of(ctx).pop();
                      BrutalToast.showSuccess(
                        context,
                        title: 'PEMINDAHAN ANTAR POS BERHASIL',
                        message: 'Rp ${MoneyFormatter.formatWithoutSymbol(amount)} dipindahkan ke pos "${destEnvelope.name}".',
                        pushToSystem: true,
                      );
                    }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModeButton(String id, String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? BrutalTokens.ink : BrutalTokens.paper,
            borderRadius: BrutalTokens.radiusZero,
            border: Border.all(
              color: BrutalTokens.ink,
              width: BrutalTokens.borderThin,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: BrutalTokens.fontUi,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: isActive ? BrutalTokens.paper : BrutalTokens.ink,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab(String id, String label) {
    final isActive = _selectedFilter == id;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = id),
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isActive ? BrutalTokens.ink : BrutalTokens.paper,
            borderRadius: BrutalTokens.radiusZero,
            border: Border.all(
              color: BrutalTokens.ink,
              width: BrutalTokens.borderThin,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: BrutalTokens.fontUi,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isActive ? BrutalTokens.paper : BrutalTokens.ink,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickChip(String label, int amount, TextEditingController ctrl) {
    return GestureDetector(
      onTap: () => ctrl.text = amount.toString(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: BrutalTokens.paper,
          border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
        ),
        child: Text(
          '+$label',
          style: const TextStyle(
            fontFamily: BrutalTokens.fontUi,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: BrutalTokens.ink,
          ),
        ),
      ),
    );
  }
}
