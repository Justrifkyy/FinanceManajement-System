import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/core/utils/date_helper.dart';
import 'package:runway_finance/core/utils/id_generator.dart';
import 'package:runway_finance/core/utils/money_formatter.dart';
import 'package:runway_finance/data/database/app_database.dart';
import 'package:runway_finance/domain/entities/transaction_entity.dart';
import 'package:runway_finance/domain/pacing.dart';
import 'package:runway_finance/providers/repository_providers.dart';
import 'package:runway_finance/providers/runway_provider.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_button.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_progress_bar.dart';
import 'package:runway_finance/shared/widgets/brutal/page_headers.dart';
import 'package:runway_finance/shared/widgets/brutal/stamp.dart';

class FutureScreen extends ConsumerWidget {
  const FutureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalDao = ref.watch(goalDaoProvider);
    final runwayAsync = ref.watch(runwayProvider);
    final todayStr = DateHelper.todayLocalDateString();

    return Scaffold(
      backgroundColor: BrutalTokens.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
          children: [
            PageHeader(
              eyebrow: 'BERTAHAN, LALU TUMBUH',
              title: 'Target',
              onProfile: () => context.push('/profile'),
            ),

            // 1. Target & Impian Section (Support Multiple Goals)
            StreamBuilder<List<GoalsTableData>>(
              stream: goalDao.watchActiveGoals(),
              builder: (context, snapshot) {
                final goals = snapshot.data ?? [];

                // Empty state jika belum ada target sama sekali
                if (goals.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: BrutalTokens.goal,
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
                            Stamp(text: 'TARGET BARU', backgroundColor: BrutalTokens.paper),
                            Icon(Icons.track_changes, size: 32, color: BrutalTokens.ink),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'BELUM ADA TARGET',
                          style: TextStyle(
                            fontFamily: BrutalTokens.fontUi,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: BrutalTokens.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Bikin impianmu jadi nyata',
                          style: TextStyle(
                            fontFamily: BrutalTokens.fontUi,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: BrutalTokens.ink,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Tentukan barang, dana liburan, gadget, atau impian yang ingin kamu capai.',
                          style: TextStyle(
                            fontFamily: BrutalTokens.fontUi,
                            fontSize: 13,
                            color: BrutalTokens.ink,
                          ),
                        ),
                        const SizedBox(height: 18),
                        BrutalButton(
                          text: '+ BUAT TARGET PERTAMA',
                          variant: BrutalButtonVariant.neutral,
                          isFullWidth: true,
                          onPressed: () => _showAddGoalDialog(context, ref),
                        ),
                      ],
                    ),
                  );
                }

                // Jika sudah ada target (satu atau lebih)
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Bar: Jumlah Target & Tombol Aksi Cepat
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'TARGET IMPIAN',
                              style: TextStyle(
                                fontFamily: BrutalTokens.fontUi,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                                color: BrutalTokens.ink,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              color: BrutalTokens.ink,
                              child: Text(
                                '${goals.length}',
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontNumbers,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: BrutalTokens.paper,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Tombol Tambah Target Baru
                            GestureDetector(
                              onTap: () => _showAddGoalDialog(context, ref),
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
                                    Icon(Icons.add, size: 14, color: BrutalTokens.ink),
                                    SizedBox(width: 4),
                                    Text(
                                      'TARGET BARU',
                                      style: TextStyle(
                                        fontFamily: BrutalTokens.fontUi,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5,
                                        color: BrutalTokens.ink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Tombol Setor Dana (Memilih Target)
                            GestureDetector(
                              onTap: () => _showDepositDialog(context, ref, goals: goals),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: BrutalTokens.warn,
                                  borderRadius: BrutalTokens.radiusZero,
                                  border: Border.all(
                                    color: BrutalTokens.ink,
                                    width: BrutalTokens.borderThin,
                                  ),
                                  boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.arrow_downward, size: 14, color: BrutalTokens.ink),
                                    SizedBox(width: 4),
                                    Text(
                                      'SETOR DANA',
                                      style: TextStyle(
                                        fontFamily: BrutalTokens.fontUi,
                                        fontSize: 10,
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Daftar Semua Kartu Target
                    ...goals.map((goal) {
                      return StreamBuilder<int>(
                        stream: goalDao.watchGoalBalance(goal.id),
                        builder: (context, balSnap) {
                          final saved = balSnap.data ?? 0;
                          final target = goal.targetAmount;
                          final percent = target > 0 ? (saved / target * 100).clamp(0.0, 100.0) : 0.0;
                          final isAchieved = saved >= target;

                          final pacing = SavingsPacing.calculate(
                            targetAmount: target,
                            currentAmount: saved,
                            deadlineLocalDate: goal.deadline,
                            todayLocalDate: todayStr,
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isAchieved ? const Color(0xFFD4EDDA) : BrutalTokens.goal,
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
                                // Top Row: Status Stamp + Action Icons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stamp(
                                      text: isAchieved ? '● TERCAPAI' : 'AKTIF',
                                      backgroundColor: isAchieved ? BrutalTokens.safe : BrutalTokens.paper,
                                    ),
                                    Row(
                                      children: [
                                        // Edit Goal Button
                                        InkWell(
                                          onTap: () => _showEditGoalDialog(context, ref, goal),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: BrutalTokens.paper,
                                              border: Border.all(
                                                color: BrutalTokens.ink,
                                                width: BrutalTokens.borderThin,
                                              ),
                                            ),
                                            child: const Icon(Icons.edit_outlined, size: 16, color: BrutalTokens.ink),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        // Delete Goal Button
                                        InkWell(
                                          onTap: () => _showDeleteGoalDialog(context, ref, goal, saved),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: BrutalTokens.paper,
                                              border: Border.all(
                                                color: BrutalTokens.ink,
                                                width: BrutalTokens.borderThin,
                                              ),
                                            ),
                                            child: const Icon(Icons.delete_outline, size: 16, color: BrutalTokens.ink),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Goal Name
                                Text(
                                  goal.name,
                                  style: const TextStyle(
                                    fontFamily: BrutalTokens.fontUi,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    height: 1.05,
                                    color: BrutalTokens.ink,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Amount & Percentage
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      MoneyFormatter.format(saved),
                                      style: const TextStyle(
                                        fontFamily: BrutalTokens.fontNumbers,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: BrutalTokens.ink,
                                      ),
                                    ),
                                    Text(
                                      'dari ${MoneyFormatter.format(target)} (${percent.toStringAsFixed(0)}%)',
                                      style: const TextStyle(
                                        fontFamily: BrutalTokens.fontUi,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: BrutalTokens.ink,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                BrutalProgressBar(value: percent, height: 16),
                                const SizedBox(height: 12),

                                // Pacing Box (if deadline is set)
                                if (!isAchieved && pacing.requiredPerDay != null && pacing.requiredPerDay! > 0)
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: BrutalTokens.paper,
                                      borderRadius: BrutalTokens.radiusZero,
                                      border: Border.all(
                                        color: BrutalTokens.ink,
                                        width: BrutalTokens.borderThin,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today_outlined, size: 20, color: BrutalTokens.ink),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'SISA ${pacing.daysRemaining ?? 0} HARI LAGI (Tenggat: ${goal.deadline ?? "-"})',
                                                style: const TextStyle(
                                                  fontFamily: BrutalTokens.fontUi,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 0.6,
                                                  color: BrutalTokens.ink,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Sisihkan ${MoneyFormatter.format(pacing.requiredPerDay!)} / hari',
                                                style: const TextStyle(
                                                  fontFamily: BrutalTokens.fontUi,
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
                                  ),
                                if (isAchieved)
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: BrutalTokens.paper,
                                      border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                                    ),
                                    child: const Row(
                                      children: [
                                        Text('🎉', style: TextStyle(fontSize: 18)),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Target impian sudah tercapai! Siap dibelanjakan atau ditarik.',
                                            style: TextStyle(
                                              fontFamily: BrutalTokens.fontUi,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: BrutalTokens.ink,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 14),

                                // Action Buttons (Setor Dana & Tarik Dana)
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => _showDepositDialog(
                                          context,
                                          ref,
                                          defaultGoalId: goal.id,
                                          goals: goals,
                                        ),
                                        child: Container(
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: BrutalTokens.paper,
                                            borderRadius: BrutalTokens.radiusZero,
                                            border: Border.all(
                                              color: BrutalTokens.ink,
                                              width: BrutalTokens.borderBase,
                                            ),
                                            boxShadow: BrutalTokens.hardShadow(offset: 3),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add_circle_outline, size: 16, color: BrutalTokens.ink),
                                              SizedBox(width: 6),
                                              Text(
                                                'SETOR KE SINI',
                                                style: TextStyle(
                                                  fontFamily: BrutalTokens.fontUi,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 0.5,
                                                  color: BrutalTokens.ink,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (saved > 0) ...[
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () => _showWithdrawDialog(context, ref, goal, saved),
                                        child: Container(
                                          height: 44,
                                          padding: const EdgeInsets.symmetric(horizontal: 14),
                                          decoration: BoxDecoration(
                                            color: BrutalTokens.paper,
                                            borderRadius: BrutalTokens.radiusZero,
                                            border: Border.all(
                                              color: BrutalTokens.ink,
                                              width: BrutalTokens.borderBase,
                                            ),
                                            boxShadow: BrutalTokens.hardShadow(offset: 3),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.arrow_upward, size: 16, color: BrutalTokens.ink),
                                              SizedBox(width: 4),
                                              Text(
                                                'TARIK',
                                                style: TextStyle(
                                                  fontFamily: BrutalTokens.fontUi,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w800,
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
                          );
                        },
                      );
                    }),
                  ],
                );
              },
            ),

            const SizedBox(height: 10),
            const SectionTitle(title: 'Dana darurat'),

            // 2. Emergency Card (Dana Darurat 6 Bulan)
            runwayAsync.when(
              data: (state) {
                final monthlySpend = (state.avgDailySpend ?? 100000) * 30;
                final emergencyTarget = monthlySpend * 6;
                final currentEmergency = state.liquidCash;
                final emergencyPercent = emergencyTarget > 0
                    ? (currentEmergency / emergencyTarget * 100).clamp(0.0, 100.0)
                    : 0.0;
                final monthsSecured = monthlySpend > 0 ? (currentEmergency / monthlySpend).toStringAsFixed(1) : '0';

                return Container(
                  padding: const EdgeInsets.all(16),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PONDASI AMAN',
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
                                '$monthsSecured dari 6 bulan',
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${emergencyPercent.toInt()}%',
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontNumbers,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: BrutalTokens.ink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      BrutalProgressBar(
                        value: emergencyPercent,
                        height: 20,
                        fillColor: BrutalTokens.buffer,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Kas Likuid',
                            style: TextStyle(
                              fontFamily: BrutalTokens.fontUi,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: BrutalTokens.ink,
                            ),
                          ),
                          Text(
                            MoneyFormatter.format(currentEmergency),
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontNumbers,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: BrutalTokens.ink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: BrutalTokens.ink,
                              width: BrutalTokens.borderThin,
                            ),
                          ),
                        ),
                        child: Text(
                          state.runwayDays != null && state.runwayDays! >= 30
                              ? 'Runway lewat 30 hari! Mulai isi pos target impian.'
                              : 'Fokus penuhi runway 30 hari dulu sebelum investasi.',
                          style: const TextStyle(
                            fontFamily: BrutalTokens.fontUi,
                            fontSize: 12,
                            color: BrutalTokens.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // DIALOG: TAMBAH TARGET BARU
  // =========================================================================
  void _showAddGoalDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    int selectedDurationDays = 180; // Default 6 bulan
    DateTime targetDeadline = DateTime.now().add(const Duration(days: 180));
    final goalDao = ref.read(goalDaoProvider);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: BrutalTokens.canvas,
          shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
          title: const Text(
            'BUAT TARGET BARU',
            style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Target (misal: Laptop Baru)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nominal Target (Rp)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Target Tercapai Dalam:',
                  style: TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 11, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _durationChip(30, '1 Bulan', selectedDurationDays, (days) {
                      setDialogState(() {
                        selectedDurationDays = days;
                        targetDeadline = DateTime.now().add(Duration(days: days));
                      });
                    }),
                    _durationChip(90, '3 Bulan', selectedDurationDays, (days) {
                      setDialogState(() {
                        selectedDurationDays = days;
                        targetDeadline = DateTime.now().add(Duration(days: days));
                      });
                    }),
                    _durationChip(180, '6 Bulan', selectedDurationDays, (days) {
                      setDialogState(() {
                        selectedDurationDays = days;
                        targetDeadline = DateTime.now().add(Duration(days: days));
                      });
                    }),
                    _durationChip(365, '1 Tahun', selectedDurationDays, (days) {
                      setDialogState(() {
                        selectedDurationDays = days;
                        targetDeadline = DateTime.now().add(Duration(days: days));
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: targetDeadline,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (picked != null) {
                      setDialogState(() {
                        targetDeadline = picked;
                        selectedDurationDays = picked.difference(DateTime.now()).inDays;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: BrutalTokens.paper,
                      border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tenggat: ${DateHelper.toLocalDateString(targetDeadline)}',
                          style: const TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                        const Icon(Icons.calendar_month, size: 16, color: BrutalTokens.ink),
                      ],
                    ),
                  ),
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
              text: 'SIMPAN',
              variant: BrutalButtonVariant.primary,
              onPressed: () async {
                final targetAmt = int.tryParse(amountCtrl.text.replaceAll('.', '').trim()) ?? 0;
                final name = nameCtrl.text.trim();
                if (name.isNotEmpty && targetAmt > 0) {
                  final deadlineStr = DateHelper.toLocalDateString(targetDeadline);
                  await goalDao.insertGoal(
                    GoalsTableCompanion.insert(
                      id: IdGenerator.nextId(),
                      name: name,
                      type: 'goal',
                      targetAmount: targetAmt,
                      deadline: drift.Value(deadlineStr),
                      status: 'active',
                      createdAt: DateTime.now().toUtc(),
                    ),
                  );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // DIALOG: EDIT TARGET
  // =========================================================================
  void _showEditGoalDialog(BuildContext context, WidgetRef ref, GoalsTableData goal) {
    final nameCtrl = TextEditingController(text: goal.name);
    final amountCtrl = TextEditingController(text: goal.targetAmount.toString());
    DateTime targetDeadline = goal.deadline != null
        ? DateTime.tryParse(goal.deadline!) ?? DateTime.now().add(const Duration(days: 180))
        : DateTime.now().add(const Duration(days: 180));
    final goalDao = ref.read(goalDaoProvider);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: BrutalTokens.canvas,
          shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
          title: const Text(
            'EDIT TARGET',
            style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Target',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nominal Target (Rp)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tenggat Waktu:',
                  style: TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 11, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: targetDeadline,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (picked != null) {
                      setDialogState(() => targetDeadline = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: BrutalTokens.paper,
                      border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateHelper.toLocalDateString(targetDeadline),
                          style: const TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                        const Icon(Icons.calendar_month, size: 16, color: BrutalTokens.ink),
                      ],
                    ),
                  ),
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
              text: 'SIMPAN',
              variant: BrutalButtonVariant.primary,
              onPressed: () async {
                final targetAmt = int.tryParse(amountCtrl.text.replaceAll('.', '').trim()) ?? 0;
                final name = nameCtrl.text.trim();
                if (name.isNotEmpty && targetAmt > 0) {
                  final deadlineStr = DateHelper.toLocalDateString(targetDeadline);
                  await goalDao.updateGoalDetails(
                    id: goal.id,
                    name: name,
                    targetAmount: targetAmt,
                    deadline: deadlineStr,
                  );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // DIALOG: HAPUS TARGET (DENGAN PENCAIRAN SALDO JIKA ADA)
  // =========================================================================
  void _showDeleteGoalDialog(BuildContext context, WidgetRef ref, GoalsTableData goal, int savedAmount) {
    final goalDao = ref.read(goalDaoProvider);
    final txRepo = ref.read(transactionRepositoryProvider);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BrutalTokens.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
        title: const Text(
          'HAPUS TARGET?',
          style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yakin ingin menghapus target "${goal.name}"?',
              style: const TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 14),
            ),
            if (savedAmount > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: BrutalTokens.warn,
                  border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                ),
                child: Text(
                  'Perhatian: Target ini masih memiliki saldo terkumpul ${MoneyFormatter.format(savedAmount)}. Dana ini dapat dikembalikan ke saldo kas belum dialokasikan secara otomatis.',
                  style: const TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
        actions: [
          BrutalButton(
            text: 'BATAL',
            variant: BrutalButtonVariant.neutral,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          if (savedAmount > 0)
            BrutalButton(
              text: 'TARIK & HAPUS',
              variant: BrutalButtonVariant.safe,
              onPressed: () async {
                // Tarik dana kembali ke unassigned
                await txRepo.recordTransaction(
                  id: IdGenerator.nextId(),
                  type: TransactionType.goalWithdraw,
                  amount: savedAmount,
                  occurredAt: DateTime.now(),
                  localDate: DateHelper.todayLocalDateString(),
                  goalId: goal.id,
                  toEnvelopeId: 'unassigned',
                  note: 'Pengembalian saldo target dihapus: ${goal.name}',
                );
                await goalDao.archiveOrDeleteGoal(goal.id);
                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('✓ Saldo ${MoneyFormatter.format(savedAmount)} ditarik ke kas dan target "${goal.name}" dihapus.')),
                  );
                }
              },
            ),
          BrutalButton(
            text: 'HAPUS',
            variant: BrutalButtonVariant.danger,
            onPressed: () async {
              await goalDao.archiveOrDeleteGoal(goal.id);
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✓ Target "${goal.name}" berhasil dihapus.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // DIALOG: SETOR DANA KE TARGET (DENGAN PILIHAN TARGET TUJUAN)
  // =========================================================================
  void _showDepositDialog(
    BuildContext context,
    WidgetRef ref, {
    String? defaultGoalId,
    List<GoalsTableData>? goals,
  }) async {
    final goalDao = ref.read(goalDaoProvider);
    final activeGoals = goals ?? await goalDao.getActiveGoals();

    if (activeGoals.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Belum ada target impian. Buat target terlebih dahulu!')),
        );
      }
      return;
    }

    String selectedGoalId = defaultGoalId ?? activeGoals.first.id;
    final depositCtrl = TextEditingController();
    final txRepo = ref.read(transactionRepositoryProvider);
    final envelopeRepo = ref.read(envelopeRepositoryProvider);

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final currentGoal = activeGoals.firstWhere(
            (g) => g.id == selectedGoalId,
            orElse: () => activeGoals.first,
          );

          return AlertDialog(
            backgroundColor: BrutalTokens.canvas,
            shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
            title: const Text(
              'SETOR DANA TARGET',
              style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Target Tujuan:',
                    style: TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),

                  // Dropdown Pemilihan Target
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: BrutalTokens.paper,
                      border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedGoalId,
                        isExpanded: true,
                        items: activeGoals.map((g) {
                          return DropdownMenuItem<String>(
                            value: g.id,
                            child: Text(
                              '🎯 ${g.name} (${MoneyFormatter.format(g.targetAmount)})',
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
                            setDialogState(() => selectedGoalId = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Saldo Kas Belum Dialokasikan Info
                  StreamBuilder<int>(
                    stream: envelopeRepo.watchEnvelopeBalance('unassigned'),
                    builder: (context, snapshot) {
                      final unassignedBalance = snapshot.data ?? 0;
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: BrutalTokens.paper,
                          border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Saldo Kas Tersedia:',
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
                      );
                    },
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: depositCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Nominal Setoran (Rp)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Quick Amount Chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _quickChip('50rb', 50000, depositCtrl),
                      _quickChip('100rb', 100000, depositCtrl),
                      _quickChip('250rb', 250000, depositCtrl),
                      _quickChip('500rb', 500000, depositCtrl),
                      _quickChip('1 Jt', 1000000, depositCtrl),
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
                text: 'SETOR',
                variant: BrutalButtonVariant.primary,
                onPressed: () async {
                  final depositAmt = int.tryParse(depositCtrl.text.replaceAll('.', '').trim()) ?? 0;
                  if (depositAmt <= 0) return;

                  final now = DateTime.now();
                  final localDate = DateHelper.todayLocalDateString();

                  await txRepo.recordTransaction(
                    id: IdGenerator.nextId(),
                    type: TransactionType.goalDeposit,
                    amount: depositAmt,
                    occurredAt: now,
                    localDate: localDate,
                    fromEnvelopeId: 'unassigned',
                    goalId: currentGoal.id,
                    note: 'Setor target: ${currentGoal.name}',
                  );

                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('✓ Berhasil menyetor Rp ${MoneyFormatter.formatWithoutSymbol(depositAmt)} ke "${currentGoal.name}"!')),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // =========================================================================
  // DIALOG: TARIK DANA DARI TARGET KE SALDO KAS
  // =========================================================================
  void _showWithdrawDialog(BuildContext context, WidgetRef ref, GoalsTableData goal, int currentBalance) {
    final withdrawCtrl = TextEditingController();
    final txRepo = ref.read(transactionRepositoryProvider);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BrutalTokens.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
        title: Text(
          'TARIK DARI ${goal.name.toUpperCase()}',
          style: const TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo terkumpul saat ini: ${MoneyFormatter.format(currentBalance)}',
              style: const TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Dana yang ditarik akan masuk kembali ke kas belum dialokasikan.',
              style: TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 11, color: BrutalTokens.muted),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: withdrawCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal Penarikan (Rp)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                GestureDetector(
                  onTap: () => withdrawCtrl.text = (currentBalance ~/ 2).toString(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: BrutalTokens.paper,
                      border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                    ),
                    child: const Text('Tarik 50%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => withdrawCtrl.text = currentBalance.toString(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: BrutalTokens.paper,
                      border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                    ),
                    child: const Text('Tarik Semua', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          BrutalButton(
            text: 'BATAL',
            variant: BrutalButtonVariant.neutral,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          BrutalButton(
            text: 'TARIK DANA',
            variant: BrutalButtonVariant.safe,
            onPressed: () async {
              final withdrawAmt = int.tryParse(withdrawCtrl.text.replaceAll('.', '').trim()) ?? 0;
              if (withdrawAmt > 0 && withdrawAmt <= currentBalance) {
                final now = DateTime.now();
                final localDate = DateHelper.todayLocalDateString();
                await txRepo.recordTransaction(
                  id: IdGenerator.nextId(),
                  type: TransactionType.goalWithdraw,
                  amount: withdrawAmt,
                  occurredAt: now,
                  localDate: localDate,
                  goalId: goal.id,
                  toEnvelopeId: 'unassigned',
                  note: 'Tarik target: ${goal.name}',
                );
                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('✓ Berhasil menarik Rp ${MoneyFormatter.formatWithoutSymbol(withdrawAmt)} dari ${goal.name} ke kas!')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  static Widget _durationChip(int days, String label, int currentSelected, ValueChanged<int> onSelect) {
    final isSelected = days == currentSelected;
    return GestureDetector(
      onTap: () => onSelect(days),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? BrutalTokens.ink : BrutalTokens.paper,
          border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: BrutalTokens.fontUi,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: isSelected ? BrutalTokens.paper : BrutalTokens.ink,
          ),
        ),
      ),
    );
  }

  static Widget _quickChip(String label, int amount, TextEditingController ctrl) {
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
