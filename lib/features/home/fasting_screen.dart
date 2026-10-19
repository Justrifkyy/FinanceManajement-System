import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/core/utils/date_helper.dart';
import 'package:runway_finance/core/utils/id_generator.dart';
import 'package:runway_finance/core/utils/money_formatter.dart';
import 'package:runway_finance/data/database/app_database.dart';
import 'package:runway_finance/providers/repository_providers.dart';
import 'package:runway_finance/providers/streak_provider.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_button.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_toast.dart';
import 'package:runway_finance/shared/widgets/brutal/page_headers.dart';
import 'package:runway_finance/shared/widgets/brutal/stamp.dart';

class FastingScreen extends ConsumerStatefulWidget {
  const FastingScreen({super.key});

  @override
  ConsumerState<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends ConsumerState<FastingScreen> {
  @override
  Widget build(BuildContext context) {
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

            // 1. Fasting Hero Card (Streak Aktif)
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
              loading: () => const Center(child: CircularProgressIndicator(color: BrutalTokens.ink)),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Tombol Aksi: Catat Godaan yang Berhasil Ditahan
            BrutalButton(
              text: '🔥 CATAT GODAAN DITAHAN (HEMAT)',
              variant: BrutalButtonVariant.safe,
              isFullWidth: true,
              icon: const Icon(Icons.shield_outlined, size: 20, color: BrutalTokens.ink),
              onPressed: () => _showRecordResistedDialog(context, txRepo),
            ),
            const SizedBox(height: 16),

            // 2. Streak Metrics (Rekor Terbaik & Total Diselamatkan)
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
                                'UANG DIHEMAT',
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

            // 3. Fasting Calendar (Dihubungkan Dinamis ke Data Pengeluaran Wants)
            FutureBuilder<Set<String>>(
              future: txRepo.getWantsExpenseDates(),
              builder: (context, snapshot) {
                final wantsDates = snapshot.data ?? {};

                return Container(
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
                          final dateStr =
                              '${now.year}-${now.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

                          final hadWants = wantsDates.contains(dateStr);

                          Color bg;
                          if (isFuture) {
                            bg = BrutalTokens.disabled;
                          } else if (hadWants) {
                            bg = BrutalTokens.danger;
                          } else {
                            bg = BrutalTokens.safe;
                          }

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
                                  Positioned(
                                    right: 2,
                                    bottom: 0,
                                    child: Text(
                                      hadWants ? '✖' : '✓',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        color: hadWants ? BrutalTokens.paper : BrutalTokens.ink,
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
                              const Text('JAJAN KELUAR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SectionTitle(title: 'Riwayat momen kamu menang'),

            // 4. Daftar Momen Menang (Resisted Events Stream)
            StreamBuilder<List<ResistedEventsTableData>>(
              stream: txRepo.watchAllResistedEvents(),
              builder: (context, snapshot) {
                final events = snapshot.data ?? [];

                if (events.isEmpty) {
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
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stamp(text: 'SIAP MULAI', backgroundColor: BrutalTokens.paper),
                        SizedBox(height: 12),
                        Text(
                          'Belum ada godaan yang dicatat',
                          style: TextStyle(
                            fontFamily: BrutalTokens.fontUi,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: BrutalTokens.ink,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Saat ada keinginan jajan impulsif dan kamu berhasil menahan diri, ketuk tombol di atas untuk mencatat kemenanganmu!',
                          style: TextStyle(
                            fontFamily: BrutalTokens.fontUi,
                            fontSize: 12,
                            color: BrutalTokens.ink,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: events.take(15).map((ev) {
                    final timeStr = DateFormat('dd MMM yyyy · HH:mm').format(ev.occurredAt.toLocal());
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: BrutalTokens.paper,
                        border: Border.all(
                          color: BrutalTokens.ink,
                          width: BrutalTokens.borderThin,
                        ),
                        boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: BrutalTokens.safe,
                              border: Border.all(
                                color: BrutalTokens.ink,
                                width: BrutalTokens.borderThin,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text('🔥', style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'BERHASIL TAHAN GODAAN',
                                  style: TextStyle(
                                    fontFamily: BrutalTokens.fontUi,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: BrutalTokens.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$timeStr WITA',
                                  style: const TextStyle(
                                    fontFamily: BrutalTokens.fontNumbers,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: BrutalTokens.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '+${MoneyFormatter.format(ev.amount)}',
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontNumbers,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: BrutalTokens.ink,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 14),

            const Text(
              '*Setiap kali kamu menahan jajan impulsif, uang tersebut tetap berada di kas dan memperpanjang hari hidup di Runway.',
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

  void _showRecordResistedDialog(BuildContext context, dynamic txRepo) {
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: BrutalTokens.canvas,
      shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Stamp(text: 'CATAT KEMENANGAN', backgroundColor: BrutalTokens.safe),
                  IconButton(
                    icon: const Icon(Icons.close, color: BrutalTokens.ink),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Berapa yang berhasil kamu hemat?',
                style: TextStyle(
                  fontFamily: BrutalTokens.fontUi,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: BrutalTokens.ink,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Masukkan estimasi harga jajan/keinginan yang batal kamu beli.',
                style: TextStyle(
                  fontFamily: BrutalTokens.fontUi,
                  fontSize: 11,
                  color: BrutalTokens.muted,
                ),
              ),
              const SizedBox(height: 14),

              // Input Nominal
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
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontFamily: BrutalTokens.fontNumbers,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: BrutalTokens.ink,
                  ),
                  decoration: const InputDecoration(
                    prefixText: 'Rp ',
                    prefixStyle: TextStyle(
                      fontFamily: BrutalTokens.fontUi,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: BrutalTokens.ink,
                    ),
                    hintText: '35000',
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              BrutalButton(
                text: 'SIMPAN KEMENANGAN 🔥',
                variant: BrutalButtonVariant.safe,
                isFullWidth: true,
                onPressed: () async {
                  final amount = int.tryParse(amountController.text.trim()) ?? 0;
                  if (amount <= 0) {
                    BrutalToast.showError(
                      context,
                      title: 'NOMINAL TIDAK VALID',
                      message: 'Masukkan nominal rupiah di atas 0!',
                      pushToSystem: true,
                    );
                    return;
                  }

                  final now = DateTime.now();
                  final localDate = DateHelper.todayLocalDateString();

                  await txRepo.recordResistedEvent(
                    id: IdGenerator.nextId(),
                    amount: amount,
                    occurredAt: now,
                    localDate: localDate,
                  );

                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                    BrutalToast.showSuccess(
                      context,
                      title: 'DISIPLIN PUASA JAJAN!',
                      message:
                          '🔥 HEBAT! Rp ${MoneyFormatter.formatWithoutSymbol(amount)} berhasil kamu selamatkan. Streak bertambah!',
                      pushToSystem: true,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
