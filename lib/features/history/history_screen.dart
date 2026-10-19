import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/core/utils/date_helper.dart';
import 'package:runway_finance/core/utils/money_formatter.dart';
import 'package:runway_finance/data/repositories/transaction_repository.dart';
import 'package:runway_finance/domain/entities/envelope_entity.dart';
import 'package:runway_finance/domain/entities/transaction_entity.dart';
import 'package:runway_finance/providers/repository_providers.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_button.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_toast.dart';
import 'package:runway_finance/shared/widgets/brutal/page_headers.dart';
import 'package:runway_finance/shared/widgets/brutal/stamp.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _selectedFilter = 'SEMUA'; // SEMUA, KELUAR, MASUK, ALOKASI, HEMAT
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txRepo = ref.watch(transactionRepositoryProvider);
    final envelopeRepo = ref.watch(envelopeRepositoryProvider);

    return Scaffold(
      backgroundColor: BrutalTokens.canvas,
      body: SafeArea(
        child: Column(
          children: [
            // Header Top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: DetailHeader(
                eyebrow: 'BUKU BESAR & LOG TRANSAKSI',
                title: 'Riwayat transaksi',
                onBack: () => context.pop(),
              ),
            ),

            // Search Bar & Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Search Box
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
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim().toLowerCase();
                        });
                      },
                      style: const TextStyle(
                        fontFamily: BrutalTokens.fontUi,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: BrutalTokens.ink,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Cari catatan, amplop, deskripsi (misal: permen kapas)...',
                        hintStyle: const TextStyle(
                          fontFamily: BrutalTokens.fontUi,
                          fontSize: 12,
                          color: BrutalTokens.muted,
                        ),
                        prefixIcon: const Icon(Icons.search, color: BrutalTokens.ink, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18, color: BrutalTokens.ink),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['SEMUA', 'KELUAR', 'MASUK', 'ALOKASI', 'HEMAT'].map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = filter),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? BrutalTokens.warn : BrutalTokens.paper,
                              border: Border.all(
                                color: BrutalTokens.ink,
                                width: BrutalTokens.borderThin,
                              ),
                              boxShadow: isSelected
                                  ? BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm)
                                  : null,
                            ),
                            child: Text(
                              filter,
                              style: const TextStyle(
                                fontFamily: BrutalTokens.fontUi,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                                color: BrutalTokens.ink,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Main List Transactions Stream
            Expanded(
              child: StreamBuilder<List<EnvelopeEntity>>(
                stream: envelopeRepo.watchActiveEnvelopes(),
                builder: (context, envSnapshot) {
                  final envelopes = envSnapshot.data ?? [];
                  final envMap = {for (final e in envelopes) e.id: e};

                  return StreamBuilder<List<TransactionEntity>>(
                    stream: txRepo.watchRecentTransactions(limit: 300),
                    builder: (context, txSnapshot) {
                      if (txSnapshot.connectionState == ConnectionState.waiting && !txSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator(color: BrutalTokens.ink));
                      }

                      final allTransactions = txSnapshot.data ?? [];

                      // Filter berdasarkan tipe
                      List<TransactionEntity> filtered = allTransactions.where((tx) {
                        if (_selectedFilter == 'KELUAR') {
                          return tx.type == TransactionType.expense;
                        } else if (_selectedFilter == 'MASUK') {
                          return tx.type == TransactionType.income;
                        } else if (_selectedFilter == 'ALOKASI') {
                          return tx.type == TransactionType.allocation ||
                              tx.type == TransactionType.transfer;
                        }
                        return true;
                      }).toList();

                      // Filter berdasarkan query pencarian (deskripsi atau nama amplop)
                      if (_searchQuery.isNotEmpty) {
                        filtered = filtered.where((tx) {
                          final note = (tx.note ?? '').toLowerCase();
                          final fromName = (envMap[tx.fromEnvelopeId]?.name ?? '').toLowerCase();
                          final toName = (envMap[tx.toEnvelopeId]?.name ?? '').toLowerCase();
                          final amountStr = tx.amount.toString();
                          return note.contains(_searchQuery) ||
                              fromName.contains(_searchQuery) ||
                              toName.contains(_searchQuery) ||
                              amountStr.contains(_searchQuery);
                        }).toList();
                      }

                      // Hitung Ringkasan KPI
                      int totalIn = 0;
                      int totalOut = 0;
                      for (final tx in allTransactions) {
                        if (tx.type == TransactionType.income) {
                          totalIn += tx.amount;
                        } else if (tx.type == TransactionType.expense) {
                          totalOut += tx.amount;
                        }
                      }

                      return Column(
                        children: [
                          // Summary KPI Banner
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: BrutalTokens.paper,
                                border: Border.all(
                                  color: BrutalTokens.ink,
                                  width: BrutalTokens.borderThin,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'MASUK: ',
                                        style: TextStyle(
                                          fontFamily: BrutalTokens.fontUi,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          color: BrutalTokens.ink,
                                        ),
                                      ),
                                      Text(
                                        MoneyFormatter.format(totalIn),
                                        style: const TextStyle(
                                          fontFamily: BrutalTokens.fontNumbers,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          color: BrutalTokens.ink,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(width: 1.5, height: 16, color: BrutalTokens.ink),
                                  Row(
                                    children: [
                                      const Text(
                                        'KELUAR: ',
                                        style: TextStyle(
                                          fontFamily: BrutalTokens.fontUi,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          color: BrutalTokens.ink,
                                        ),
                                      ),
                                      Text(
                                        MoneyFormatter.format(totalOut),
                                        style: const TextStyle(
                                          fontFamily: BrutalTokens.fontNumbers,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          color: BrutalTokens.ink,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // List grouped by date
                          Expanded(
                            child: filtered.isEmpty
                                ? Center(
                                    child: Container(
                                      margin: const EdgeInsets.all(24),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: BrutalTokens.paper,
                                        border: Border.all(
                                          color: BrutalTokens.ink,
                                          width: BrutalTokens.borderBase,
                                        ),
                                        boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('📂', style: TextStyle(fontSize: 32)),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'BELUM ADA TRANSAKSI',
                                            style: TextStyle(
                                              fontFamily: BrutalTokens.fontUi,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 0.8,
                                              color: BrutalTokens.ink,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _searchQuery.isNotEmpty
                                                ? 'Tidak ditemukan transaksi dengan kata kunci "$_searchQuery".'
                                                : 'Mulai catat gerak uang dari Beranda.',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: BrutalTokens.fontUi,
                                              fontSize: 11,
                                              color: BrutalTokens.muted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                    itemCount: filtered.length,
                                    itemBuilder: (context, index) {
                                      final tx = filtered[index];
                                      final showDateHeader = index == 0 ||
                                          filtered[index - 1].localDate != tx.localDate;

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (showDateHeader) ...[
                                            const SizedBox(height: 12),
                                            _buildDateHeader(tx.localDate),
                                            const SizedBox(height: 6),
                                          ],
                                          _buildTransactionCard(
                                            context,
                                            tx: tx,
                                            envMap: envMap,
                                            onDelete: () => _confirmDeleteTransaction(context, tx, txRepo),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(String localDate) {
    final today = DateHelper.todayLocalDateString();
    final yesterday = DateHelper.yesterdayLocalDateString();

    String label = localDate;
    if (localDate == today) {
      label = 'HARI INI · $localDate';
    } else if (localDate == yesterday) {
      label = 'KEMARIN · $localDate';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: const BoxDecoration(
        color: BrutalTokens.ink,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: BrutalTokens.fontNumbers,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
          color: BrutalTokens.paper,
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
    BuildContext context, {
    required TransactionEntity tx,
    required Map<String, EnvelopeEntity> envMap,
    required VoidCallback onDelete,
  }) {
    final isExpense = tx.type == TransactionType.expense;
    final isIncome = tx.type == TransactionType.income;
    final isAllocation = tx.type == TransactionType.allocation;
    final isTransfer = tx.type == TransactionType.transfer;

    // Kategori / Amplop
    String title = 'Transaksi';
    String? subtitle = tx.note;

    Color badgeBg = BrutalTokens.paper;
    String badgeIcon = '💳';
    Color amountColor = BrutalTokens.ink;
    String sign = '';

    if (isExpense) {
      final env = envMap[tx.fromEnvelopeId];
      title = env != null ? '${env.icon ?? ''} ${env.name}' : 'Pengeluaran';
      badgeBg = BrutalTokens.danger;
      badgeIcon = '💸';
      amountColor = BrutalTokens.ink;
      sign = '-';
    } else if (isIncome) {
      final env = envMap[tx.toEnvelopeId];
      title = env != null ? 'Masuk: ${env.name}' : 'Pemasukan Kas';
      badgeBg = BrutalTokens.safe;
      badgeIcon = '💰';
      amountColor = BrutalTokens.ink;
      sign = '+';
    } else if (isAllocation) {
      final fromEnv = envMap[tx.fromEnvelopeId];
      final toEnv = envMap[tx.toEnvelopeId];
      title = 'Alokasi: ${fromEnv?.name ?? 'Kas'} ➔ ${toEnv?.name ?? 'Pos'}';
      badgeBg = BrutalTokens.warn;
      badgeIcon = '💼';
    } else if (isTransfer) {
      final fromEnv = envMap[tx.fromEnvelopeId];
      final toEnv = envMap[tx.toEnvelopeId];
      title = 'Pindah: ${fromEnv?.name ?? 'Pos'} ➔ ${toEnv?.name ?? 'Pos'}';
      badgeBg = BrutalTokens.buffer;
      badgeIcon = '🔄';
    }

    final timeStr = DateFormat('HH:mm').format(tx.occurredAt.toLocal());

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: BrutalTokens.paper,
        border: Border.all(
          color: BrutalTokens.ink,
          width: BrutalTokens.borderBase,
        ),
        boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTransactionDetail(context, tx: tx, envMap: envMap, onDelete: onDelete),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge Icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: badgeBg,
                    border: Border.all(
                      color: BrutalTokens.ink,
                      width: BrutalTokens.borderThin,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(badgeIcon, style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 12),

                // Main Info (Title, Description, Time)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: BrutalTokens.fontUi,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: BrutalTokens.ink,
                        ),
                      ),
                      // Deskripsi Opsional Pengguna (jika ada)
                      if (subtitle != null && subtitle.trim().isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: BrutalTokens.canvas,
                            border: Border.all(
                              color: BrutalTokens.ink.withValues(alpha: 0.3),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            'deskripsi : $subtitle',
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontUi,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: BrutalTokens.ink,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      const SizedBox(height: 3),
                      Text(
                        '$timeStr WITA',
                        style: const TextStyle(
                          fontFamily: BrutalTokens.fontNumbers,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: BrutalTokens.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Amount Display
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$sign${MoneyFormatter.format(tx.amount)}',
                      style: TextStyle(
                        fontFamily: BrutalTokens.fontNumbers,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: amountColor,
                      ),
                    ),
                    if (isExpense && tx.countsAsSpending)
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: BrutalTokens.ink,
                          borderRadius: BrutalTokens.radiusZero,
                        ),
                        child: const Text(
                          'RUNWAY',
                          style: TextStyle(
                            fontFamily: BrutalTokens.fontNumbers,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: BrutalTokens.paper,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTransactionDetail(
    BuildContext context, {
    required TransactionEntity tx,
    required Map<String, EnvelopeEntity> envMap,
    required VoidCallback onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: BrutalTokens.canvas,
      shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
      builder: (ctx) {
        final fromEnv = envMap[tx.fromEnvelopeId];
        final toEnv = envMap[tx.toEnvelopeId];
        final timeFull = DateFormat('dd MMMM yyyy · HH:mm:ss').format(tx.occurredAt.toLocal());

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Stamp(text: 'DETAIL TRANSAKSI', backgroundColor: BrutalTokens.paper),
                  IconButton(
                    icon: const Icon(Icons.close, color: BrutalTokens.ink),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Nominal Besar
              Text(
                MoneyFormatter.format(tx.amount),
                style: const TextStyle(
                  fontFamily: BrutalTokens.fontNumbers,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: BrutalTokens.ink,
                ),
              ),
              const SizedBox(height: 12),

              // Info Bar
              _buildDetailRow('TIPE', tx.type.value.toUpperCase()),
              _buildDetailRow('WAKTU', '$timeFull WITA'),
              if (fromEnv != null) _buildDetailRow('DARI POS', fromEnv.name),
              if (toEnv != null) _buildDetailRow('MENUJU POS', toEnv.name),
              if (tx.note != null && tx.note!.isNotEmpty)
                _buildDetailRow('DESKRIPSI', tx.note!),
              _buildDetailRow('HITUNG PENGELUARAN', tx.countsAsSpending ? 'YA' : 'TIDAK'),

              const SizedBox(height: 20),

              // Tombol Hapus
              BrutalButton(
                text: 'HAPUS TRANSAKSI INI',
                variant: BrutalButtonVariant.danger,
                isFullWidth: true,
                icon: const Icon(Icons.delete_outline, size: 20, color: BrutalTokens.ink),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: BrutalTokens.fontUi,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: BrutalTokens.muted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: BrutalTokens.fontUi,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: BrutalTokens.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTransaction(
    BuildContext context,
    TransactionEntity tx,
    TransactionRepository txRepo,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BrutalTokens.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
        title: const Text(
          'HAPUS TRANSAKSI?',
          style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
        ),
        content: Text(
          'Transaksi sebesar ${MoneyFormatter.format(tx.amount)} akan dihapus dari buku besar. Saldo kas & runway akan otomatis dihitung ulang.',
          style: const TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 13),
        ),
        actions: [
          BrutalButton(
            text: 'BATAL',
            variant: BrutalButtonVariant.neutral,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          BrutalButton(
            text: 'HAPUS',
            variant: BrutalButtonVariant.danger,
            onPressed: () async {
              Navigator.of(ctx).pop();
              await txRepo.deleteTransaction(tx.id);
              if (context.mounted) {
                BrutalToast.showSuccess(
                  context,
                  title: 'TRANSAKSI DIHAPUS',
                  message: 'Data ${MoneyFormatter.format(tx.amount)} telah dihapus dari buku besar.',
                  pushToSystem: true,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
