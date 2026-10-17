import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/core/utils/date_helper.dart';
import 'package:runway_finance/core/utils/money_formatter.dart';
import 'package:runway_finance/providers/repository_providers.dart';
import 'package:runway_finance/providers/streak_provider.dart';
import 'package:runway_finance/shared/widgets/brutal/page_headers.dart';
import 'package:runway_finance/shared/widgets/brutal/stamp.dart';

class FastingScreen extends ConsumerWidget {
  const FastingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakProvider);
    final txRepo = ref.watch(transactionRepositoryProvider);

    final now = DateTime.now();
    final currentDay = now.day;
    final totalDaysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final monthName = DateHelper.formatDisplayDate(now);

    return Scaffold(
      backgroundColor: BrutalTokens.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
          children: [
            DetailHeader(
              eyebrow: 'LAPORAN KETAHANAN GODAAN',
              title: 'Puasa jajan',
              onBack: () => context.pop(),
            ),

            // Fasting Hero Card
            streakAsync.when(
              data: (streak) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BrutalTokens.goal,
                  borderRadius: BrutalTokens.radiusZero,
                  border: Border.all(
                    color: BrutalTokens.ink,
                    width: BrutalTokens.borderHeavy,
                  ),
                  boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowLg),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: BrutalTokens.paper,
                        border: Border.all(
                          color: BrutalTokens.ink,
                          width: BrutalTokens.borderThin,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text('🔥', style: TextStyle(fontSize: 30)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'STREAK SEKARANG',
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
                            '${streak.currentStreak} HARI',
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontNumbers,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: BrutalTokens.ink,
                            ),
                          ),
                          Text(
                            streak.currentStreak > 0
                                ? 'Dompetmu menang ${streak.currentStreak} hari berturut-turut.'
                                : 'Mulai menahan godaan jajan hari ini!',
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
                    const Stamp(text: 'LANJUT!'),
                  ],
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),

            // Streak Metrics (2 boxes)
            Container(
              decoration: BoxDecoration(
                borderRadius: BrutalTokens.radiusZero,
                border: Border.all(
                  color: BrutalTokens.ink,
                  width: BrutalTokens.borderBase,
                ),
                boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: BrutalTokens.paper,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'REKOR TERBAIK',
                            style: TextStyle(
                              fontFamily: BrutalTokens.fontUi,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: BrutalTokens.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${streakAsync.asData?.value.longestStreak ?? 0} hari',
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontNumbers,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: BrutalTokens.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(width: BrutalTokens.borderThin, height: 50, color: BrutalTokens.ink),
                  Expanded(
                    child: StreamBuilder<int>(
                      stream: txRepo.watchTotalResistedAmount(),
                      builder: (context, snapshot) {
                        final totalResisted = snapshot.data ?? 0;
                        return Container(
                          padding: const EdgeInsets.all(12),
                          color: BrutalTokens.safe,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'UANG DIHEMAT*',
                                style: TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                MoneyFormatter.format(totalResisted),
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontNumbers,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SectionTitle(title: monthName),

            // Fasting Calendar
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: BrutalTokens.paper,
                borderRadius: BrutalTokens.radiusZero,
                border: Border.all(
                  color: BrutalTokens.ink,
                  width: BrutalTokens.borderBase,
                ),
                boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
              ),
              child: Column(
                children: [
                  // Weekday header
                  Row(
                    children: ['S', 'S', 'R', 'K', 'J', 'S', 'M'].map((day) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontUi,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: BrutalTokens.ink,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),

                  // Calendar Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: totalDaysInMonth,
                    itemBuilder: (context, index) {
                      final day = index + 1;
                      final isFuture = day > currentDay;

                      Color bg = isFuture ? BrutalTokens.disabled : BrutalTokens.safe;

                      return Container(
                        decoration: BoxDecoration(
                          color: bg,
                          border: Border.all(
                            color: BrutalTokens.ink,
                            width: BrutalTokens.borderThin,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              '$day',
                              style: TextStyle(
                                fontFamily: BrutalTokens.fontNumbers,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isFuture ? BrutalTokens.disabledText : BrutalTokens.ink,
                              ),
                            ),
                            if (!isFuture)
                              const Positioned(
                                right: 2,
                                bottom: 0,
                                child: Text(
                                  '✓',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: BrutalTokens.ink,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Calendar Legend
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(width: 11, height: 11, color: BrutalTokens.safe, margin: const EdgeInsets.only(right: 5)),
                          const Text('BERHASIL TAHAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Container(width: 11, height: 11, color: BrutalTokens.danger, margin: const EdgeInsets.only(right: 5)),
                          const Text('JAJAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SectionTitle(title: 'Momen kamu menang'),

            // Resisted Card
            StreamBuilder<int>(
              stream: txRepo.watchResistedEventsCount(),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BrutalTokens.safe,
                    borderRadius: BrutalTokens.radiusZero,
                    border: Border.all(
                      color: BrutalTokens.ink,
                      width: BrutalTokens.borderBase,
                    ),
                    boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Stamp(text: 'GAK JADI BELI', backgroundColor: BrutalTokens.paper),
                      const SizedBox(height: 12),
                      Text(
                        count > 0 ? '$count kali berhasil menahan godaan' : 'Belum ada godaan yang ditahan',
                        style: const TextStyle(
                          fontFamily: BrutalTokens.fontUi,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: BrutalTokens.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        count > 0
                            ? 'Setiap kali kamu menolak beli jajan, runway hidupmu bertambah.'
                            : 'Pakai Kalkulator Keringat saat ingin membeli barang keinginan.',
                        style: const TextStyle(
                          fontFamily: BrutalTokens.fontUi,
                          fontSize: 12,
                          color: BrutalTokens.ink,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            const Text(
              '*Estimasi dari transaksi yang kamu batalkan lewat Kalkulator Keringat.',
              style: TextStyle(
                fontFamily: BrutalTokens.fontUi,
                fontSize: 10,
                color: BrutalTokens.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
