import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/core/utils/date_helper.dart';
import 'package:runway_finance/core/utils/money_formatter.dart';
import 'package:runway_finance/data/database/app_database.dart';
import 'package:runway_finance/domain/runway.dart';
import 'package:runway_finance/providers/repository_providers.dart';
import 'package:runway_finance/providers/runway_provider.dart';
import 'package:runway_finance/providers/streak_provider.dart';
import 'package:runway_finance/services/backup/auth_service.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_button.dart';
import 'package:runway_finance/shared/widgets/brutal/hazard_stripes.dart';
import 'package:runway_finance/shared/widgets/brutal/page_headers.dart';
import 'package:runway_finance/shared/widgets/brutal/segment_bar.dart';
import 'package:runway_finance/shared/widgets/brutal/stamp.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runwayAsync = ref.watch(runwayProvider);
    final streakAsync = ref.watch(streakProvider);
    final transactionRepo = ref.watch(transactionRepositoryProvider);
    final userAsync = ref.watch(currentUserProvider);

    final now = DateTime.now();
    final todayFormatted = DateHelper.formatDisplayDate(now).toUpperCase();
    const daysLabels = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];

    return Scaffold(
      backgroundColor: BrutalTokens.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
          children: [
            PageHeader(
              eyebrow: todayFormatted,
              title: 'Halo, pejuang.',
              onProfile: () => context.push('/profile'),
            ),

            // 1. Health Card (Runway Daya Tahan Hidup)
            runwayAsync.when(
              data: (state) => _buildHealthCard(context, state),
              loading: () => Container(
                height: 220,
                decoration: BoxDecoration(
                  color: BrutalTokens.safe,
                  border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderHeavy),
                  boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowLg),
                ),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(color: BrutalTokens.ink),
              ),
              error: (err, stack) => Container(
                padding: const EdgeInsets.all(16),
                color: BrutalTokens.danger,
                child: Text('Error: $err'),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Pending Income Strip (Uang di jalan menunggu cair)
            StreamBuilder<int>(
              stream: transactionRepo.watchTotalPendingIncome(),
              builder: (context, snapshot) {
                final totalPending = snapshot.data ?? 0;

                return GestureDetector(
                  onTap: () => _showPendingIncomesSheet(context, ref),
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
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: BrutalTokens.warn,
                            border: Border.all(
                              color: BrutalTokens.ink,
                              width: BrutalTokens.borderThin,
                            ),
                          ),
                          child: const Icon(Icons.access_time, color: BrutalTokens.ink, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                MoneyFormatter.format(totalPending),
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontNumbers,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                totalPending > 0
                                    ? 'Uang di jalan menunggu cair (ketuk untuk kelola)'
                                    : 'Belum ada invoice/piutang pending',
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 12,
                                  color: BrutalTokens.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward, size: 20, color: BrutalTokens.ink),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Section Title: Puasa Jajan
            SectionTitle(
              title: 'Puasa jajan',
              action: 'LIHAT DETAIL',
              onAction: () => context.push('/fasting'),
            ),

            // 3. Streak Card (Real Data dari database)
            streakAsync.when(
              data: (streakState) => _buildStreakCard(context, streakState, daysLabels),
              loading: () => Container(
                height: 140,
                decoration: BoxDecoration(
                  color: BrutalTokens.goal,
                  border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderBase),
                ),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(color: BrutalTokens.ink),
              ),
              error: (_, _) => _buildStreakCard(
                context,
                const StreakState(
                  currentStreak: 0,
                  longestStreak: 0,
                  resistedCount: 0,
                  last7DaysFast: [true, true, true, true, true, true, true],
                ),
                daysLabels,
              ),
            ),
            const SizedBox(height: 20),

            // 4. Backup Banner (Klik untuk Buka Cadangan & Email)
            GestureDetector(
              onTap: () => context.push('/backup'),
              child: Container(
                decoration: BoxDecoration(
                  color: BrutalTokens.paper,
                  borderRadius: BrutalTokens.radiusZero,
                  border: Border.all(
                    color: BrutalTokens.ink,
                    width: BrutalTokens.borderBase,
                  ),
                  boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
                ),
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: HazardStripes(
                        primaryColor: BrutalTokens.warn,
                        secondaryColor: BrutalTokens.paper,
                        height: double.infinity,
                        stripeWidth: 10,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: userAsync.value?.isLoggedIn == true ? BrutalTokens.safe : BrutalTokens.warn,
                              border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                            ),
                            child: Icon(
                              userAsync.value?.isLoggedIn == true ? Icons.cloud_done : Icons.cloud_upload_outlined,
                              size: 22,
                              color: BrutalTokens.ink,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: BrutalTokens.paper,
                                border: Border.all(
                                  color: BrutalTokens.ink,
                                  width: BrutalTokens.borderThin,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userAsync.value?.isLoggedIn == true
                                        ? 'CADANGAN EMAIL & CLOUD AKTIF'
                                        : 'SIMPAN DATA KE EMAIL / GOOGLE',
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontUi,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: BrutalTokens.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userAsync.value?.isLoggedIn == true
                                        ? 'Tersambung: ${userAsync.value!.email}'
                                        : 'Ketuk untuk masuk & amankan data ke email',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontUi,
                                      fontSize: 11,
                                      color: BrutalTokens.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 18, color: BrutalTokens.ink),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(BuildContext context, RunwayState state) {
    final runwayDays = state.runwayDays;
    final liquidCash = state.liquidCash;

    final Color bgColor;
    final String stampText;
    final String description;

    if (liquidCash <= 0 && runwayDays == null) {
      bgColor = BrutalTokens.warn;
      stampText = '● SALDO KOSONG';
      description = 'Catat pemasukan pertamamu untuk mulai menghitung runway.';
    } else if (runwayDays == null) {
      bgColor = BrutalTokens.safe;
      stampText = '● AMAN';
      description = 'Uang kas utuh. Belum ada pengeluaran tercatat.';
    } else {
      switch (state.status) {
        case HealthStatus.safe:
        case HealthStatus.noData:
          bgColor = BrutalTokens.safe;
          stampText = '● AMAN';
          description = 'Daya tahan hidup stabil. Pertahankan kebiasaan baik.';
          break;
        case HealthStatus.warning:
          bgColor = BrutalTokens.warn;
          stampText = '● WASPADA';
          description = 'Mulai berhemat! Utamakan kebutuhan primer.';
          break;
        case HealthStatus.danger:
          bgColor = BrutalTokens.danger;
          stampText = '● BAHAYA';
          description = 'Zona kritis! Setop jajan sekarang!';
          break;
      }
    }

    final displayDays = runwayDays ?? (liquidCash > 0 ? 30 : 0);
    final filledSegments = (displayDays / 5).clamp(1, 10).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
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
              Flexible(
                child: Stamp(
                  text: stampText,
                  backgroundColor: BrutalTokens.paper,
                  isRotated: true,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'TARGET 30 HARI',
                style: TextStyle(
                  fontFamily: BrutalTokens.fontUi,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: BrutalTokens.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Runway number
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              runwayDays != null ? '$runwayDays' : (liquidCash > 0 ? '30+' : '0'),
              style: const TextStyle(
                fontFamily: BrutalTokens.fontNumbers,
                fontSize: 96,
                fontWeight: FontWeight.w800,
                height: 0.95,
                letterSpacing: -4.0,
                color: BrutalTokens.ink,
              ),
            ),
          ),

          // Runway unit
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            color: BrutalTokens.ink,
            child: const Text(
              'HARI',
              style: TextStyle(
                fontFamily: BrutalTokens.fontUi,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                color: BrutalTokens.paper,
              ),
            ),
          ),
          const SizedBox(height: 18),

          Text(
            description,
            style: const TextStyle(
              fontFamily: BrutalTokens.fontUi,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: BrutalTokens.ink,
            ),
          ),
          const SizedBox(height: 14),

          // Segment bar (10 blocks)
          SegmentBar(filledSegments: filledSegments),
          const SizedBox(height: 12),

          // Health foot: UANG LIKUID -> amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'UANG LIKUID',
                style: TextStyle(
                  fontFamily: BrutalTokens.fontUi,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: BrutalTokens.ink,
                ),
              ),
              Text(
                MoneyFormatter.format(liquidCash),
                style: const TextStyle(
                  fontFamily: BrutalTokens.fontNumbers,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: BrutalTokens.ink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, StreakState streak, List<String> daysLabels) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrutalTokens.goal,
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
          Row(
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
                alignment: Alignment.center,
                child: const Text('🔥', style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${streak.currentStreak} HARI',
                      style: const TextStyle(
                        fontFamily: BrutalTokens.fontNumbers,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                        color: BrutalTokens.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      streak.currentStreak > 0 ? 'Tanpa jajan. Lanjut!' : 'Mulai puasa jajan hari ini.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: BrutalTokens.fontUi,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: BrutalTokens.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Mini week checkmarks
          Row(
            children: List.generate(7, (index) {
              final isDone = index < streak.last7DaysFast.length
                  ? streak.last7DaysFast[index]
                  : false;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 6 ? 6.0 : 0.0),
                  child: Column(
                    children: [
                      Container(
                        height: 33,
                        decoration: BoxDecoration(
                          color: isDone ? BrutalTokens.ink : BrutalTokens.paper,
                          border: Border.all(
                            color: BrutalTokens.ink,
                            width: BrutalTokens.borderThin,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isDone ? '✓' : '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: isDone ? BrutalTokens.paper : BrutalTokens.ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        daysLabels[index],
                        style: const TextStyle(
                          fontFamily: BrutalTokens.fontUi,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: BrutalTokens.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),

          // Record row
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: BrutalTokens.ink,
                  width: BrutalTokens.borderThin,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'REKOR TERBAIK',
                  style: TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: BrutalTokens.ink,
                  ),
                ),
                Text(
                  '${streak.longestStreak} HARI',
                  style: const TextStyle(
                    fontFamily: BrutalTokens.fontNumbers,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: BrutalTokens.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPendingIncomesSheet(BuildContext context, WidgetRef ref) {
    final transactionRepo = ref.read(transactionRepositoryProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: BrutalTokens.canvas,
      shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'UANG DI JALAN (INVOICE/PIUTANG)',
                    style: TextStyle(
                      fontFamily: BrutalTokens.fontUi,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: BrutalTokens.ink,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: BrutalTokens.ink),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<PendingIncomesTableData>>(
                stream: transactionRepo.watchPendingIncomes(),
                builder: (context, snapshot) {
                  final list = snapshot.data ?? [];
                  if (list.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      alignment: Alignment.center,
                      child: const Text(
                        'Tidak ada uang di jalan yang aktif.',
                        style: TextStyle(
                          fontFamily: BrutalTokens.fontUi,
                          fontWeight: FontWeight.w700,
                          color: BrutalTokens.muted,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: list.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: BrutalTokens.paper,
                          border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.client ?? 'Invoice Project',
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontUi,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: BrutalTokens.ink,
                                    ),
                                  ),
                                  Text(
                                    MoneyFormatter.format(item.amount),
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontNumbers,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: BrutalTokens.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BrutalButton(
                              text: 'CAIRKAN',
                              variant: BrutalButtonVariant.primary,
                              onPressed: () async {
                                await transactionRepo.markPendingIncomeReceived(
                                  pendingIncomeId: item.id,
                                  amount: item.amount,
                                  toEnvelopeId: 'unassigned',
                                  note: 'Pencairan: ${item.client ?? 'Uang di jalan'}',
                                );
                                if (ctx.mounted) {
                                  Navigator.of(ctx).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('✓ Rp ${MoneyFormatter.formatWithoutSymbol(item.amount)} berhasil dicairkan ke Kas!'),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
