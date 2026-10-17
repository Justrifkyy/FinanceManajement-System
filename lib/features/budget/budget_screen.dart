import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/core/utils/date_helper.dart';
import 'package:runway_finance/core/utils/money_formatter.dart';
import 'package:runway_finance/data/database/app_database.dart';
import 'package:runway_finance/domain/entities/envelope_entity.dart';
import 'package:runway_finance/providers/repository_providers.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_progress_bar.dart';
import 'package:runway_finance/shared/widgets/brutal/page_headers.dart';
import 'package:runway_finance/shared/widgets/brutal/stamp.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envelopeRepo = ref.watch(envelopeRepositoryProvider);
    final subscriptionDao = ref.watch(subscriptionDaoProvider);

    // Bulan pencairan bantalan berikutnya (tanggal 1 bulan depan)
    final nextMonthDate = DateTime.now().add(const Duration(days: 32));
    final nextMonthFirstDay = DateTime(nextMonthDate.year, nextMonthDate.month, 1);
    final releaseDateFormatted = DateHelper.formatDisplayDate(nextMonthFirstDay);

    return Scaffold(
      backgroundColor: BrutalTokens.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
          children: [
            PageHeader(
              eyebrow: 'SETIAP RUPIAH BEKERJA',
              title: 'Alokasi',
              onProfile: () => context.push('/profile'),
            ),

            // 1. Unassigned Funds Card (Dana Belum Bertugas)
            StreamBuilder<int>(
              stream: envelopeRepo.watchEnvelopeBalance('unassigned'),
              builder: (context, snapshot) {
                final balance = snapshot.data ?? 0;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BrutalTokens.warn,
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stamp(
                            text: 'BELUM BERTUGAS',
                            backgroundColor: BrutalTokens.paper,
                          ),
                          Icon(Icons.account_balance_wallet_outlined, size: 30, color: BrutalTokens.ink),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'DANA BELUM DIALOKASIKAN',
                        style: TextStyle(
                          fontFamily: BrutalTokens.fontUi,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: BrutalTokens.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        MoneyFormatter.format(balance),
                        style: const TextStyle(
                          fontFamily: BrutalTokens.fontNumbers,
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.0,
                          color: BrutalTokens.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        balance > 0
                            ? 'Masih nganggur. Kasih tugas ke pos amplop kamu.'
                            : 'Semua uang sudah bertugas atau belum ada saldo masuk.',
                        style: const TextStyle(
                          fontFamily: BrutalTokens.fontUi,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: BrutalTokens.ink,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Compact Button: ATUR ALOKASI ->
                      GestureDetector(
                        onTap: () => context.push('/allocate'),
                        child: Container(
                          height: 48,
                          decoration: const BoxDecoration(
                            color: BrutalTokens.ink,
                            borderRadius: BrutalTokens.radiusZero,
                            boxShadow: [
                              BoxShadow(
                                color: BrutalTokens.paper,
                                offset: Offset(4, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ATUR ALOKASI',
                                style: TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: BrutalTokens.paper,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18, color: BrutalTokens.paper),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // 2. Buffer Card (Bantalan Bulan Depan)
            StreamBuilder<int>(
              stream: envelopeRepo.watchEnvelopeBalance('buffer'),
              builder: (context, snapshot) {
                final bufferBalance = snapshot.data ?? 0;

                return Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: BrutalTokens.buffer,
                    borderRadius: BrutalTokens.radiusZero,
                    border: Border.all(
                      color: BrutalTokens.ink,
                      width: BrutalTokens.borderBase,
                    ),
                    boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
                  ),
                  child: Row(
                    children: [
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
                        child: const Icon(Icons.lock_outline, color: BrutalTokens.ink, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'BANTALAN BULAN DEPAN',
                              style: TextStyle(
                                fontFamily: BrutalTokens.fontUi,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: BrutalTokens.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              MoneyFormatter.format(bufferBalance),
                              style: const TextStyle(
                                fontFamily: BrutalTokens.fontNumbers,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: BrutalTokens.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Cair otomatis $releaseDateFormatted',
                              style: const TextStyle(
                                fontFamily: BrutalTokens.fontUi,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: BrutalTokens.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Section Title: Amplop kamu
            SectionTitle(
              title: 'Amplop kamu',
              action: '+ KELOLA',
              onAction: () => context.push('/envelopes'),
            ),

            // 3. 2-Column Envelope Grid (Real DB Envelopes & Balances)
            StreamBuilder<List<EnvelopeEntity>>(
              stream: envelopeRepo.watchActiveEnvelopes(),
              builder: (context, snapshot) {
                final allEnvelopes = snapshot.data ?? [];
                final envelopes = allEnvelopes.where((e) => !e.isSystem).toList();

                if (envelopes.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: BrutalTokens.paper,
                      border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderBase),
                    ),
                    child: const Text(
                      'Belum ada pos amplop. Ketuk + KELOLA di atas untuk menambah.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w700),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.05,
                  ),
                  itemCount: envelopes.length,
                  itemBuilder: (context, index) {
                    final item = envelopes[index];
                    final isNeeds = item.category == EnvelopeCategory.needs;
                    final bg = isNeeds ? BrutalTokens.needs : BrutalTokens.wants;

                    return StreamBuilder<int>(
                      stream: envelopeRepo.watchEnvelopeBalance(item.id),
                      builder: (context, balSnap) {
                        final balance = balSnap.data ?? 0;
                        final percent = balance > 0 ? 100.0 : 0.0;

                        return GestureDetector(
                          onTap: () => context.push('/allocate?envelopeId=${item.id}'),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BrutalTokens.radiusZero,
                              border: Border.all(
                                color: BrutalTokens.ink,
                                width: BrutalTokens.borderBase,
                              ),
                              boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
                            ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isNeeds ? 'KEBUTUHAN' : 'KEINGINAN',
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontUi,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                      color: BrutalTokens.ink,
                                    ),
                                  ),
                                  Text(item.icon ?? '📁', style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontUi,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: BrutalTokens.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    MoneyFormatter.format(balance),
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontNumbers,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: BrutalTokens.ink,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  BrutalProgressBar(value: percent, height: 12),
                                  const SizedBox(height: 4),
                                  Text(
                                    balance > 0 ? 'Tersedia' : 'Kosong',
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontUi,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: BrutalTokens.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    );
                  },
                );
              },
            ),

            // Section Title: Radar Langganan
            SectionTitle(
              title: 'Radar langganan',
              action: 'SEMUA',
              onAction: () => context.push('/subscriptions'),
            ),

            // 4. Bill Card Preview (Upcoming Subscription)
            StreamBuilder<List<SubscriptionsTableData>>(
              stream: subscriptionDao.watchActiveSubscriptions(),
              builder: (context, snapshot) {
                final subs = snapshot.data ?? [];
                if (subs.isEmpty) {
                  return GestureDetector(
                    onTap: () => context.push('/subscriptions'),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: BrutalTokens.paper,
                        border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderBase),
                        boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add_alert_outlined, color: BrutalTokens.ink, size: 28),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '+ Tambah tagihan rutin agar radar aktif',
                              style: TextStyle(
                                fontFamily: BrutalTokens.fontUi,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: BrutalTokens.ink,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward, size: 20, color: BrutalTokens.ink),
                        ],
                      ),
                    ),
                  );
                }

                final firstSub = subs.first;
                return GestureDetector(
                  onTap: () => context.push('/subscriptions'),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: BrutalTokens.paper,
                      borderRadius: BrutalTokens.radiusZero,
                      border: Border.all(
                        color: BrutalTokens.ink,
                        width: BrutalTokens.borderBase,
                      ),
                      boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: BrutalTokens.danger,
                            border: Border.all(
                              color: BrutalTokens.ink,
                              width: BrutalTokens.borderThin,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                firstSub.nextDueDate.split('-').last,
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontNumbers,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  height: 1.0,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                              const Text(
                                'TGL',
                                style: TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'JATUH TEMPO: ${firstSub.nextDueDate}',
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: Color(0xFFB40000),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                firstSub.name,
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                              const Text(
                                'Tagihan rutin bulanan',
                                style: TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 11,
                                  color: BrutalTokens.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          MoneyFormatter.format(firstSub.amount),
                          style: const TextStyle(
                            fontFamily: BrutalTokens.fontNumbers,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: BrutalTokens.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
