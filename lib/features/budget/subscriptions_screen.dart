import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/core/utils/date_helper.dart';
import 'package:runway_finance/core/utils/id_generator.dart';
import 'package:runway_finance/core/utils/money_formatter.dart';
import 'package:runway_finance/data/database/app_database.dart';
import 'package:runway_finance/providers/notification_provider.dart';
import 'package:runway_finance/providers/repository_providers.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_button.dart';
import 'package:runway_finance/shared/widgets/brutal/page_headers.dart';

class SubscriptionsScreen extends ConsumerStatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  ConsumerState<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends ConsumerState<SubscriptionsScreen> {
  String _selectedCycle = 'monthly'; // monthly, yearly

  @override
  Widget build(BuildContext context) {
    final subDao = ref.watch(subscriptionDaoProvider);

    return Scaffold(
      backgroundColor: BrutalTokens.canvas,
      body: SafeArea(
        child: StreamBuilder<List<SubscriptionsTableData>>(
          stream: subDao.watchActiveSubscriptions(),
          builder: (context, snapshot) {
            final allSubs = snapshot.data ?? [];
            final visible = allSubs.where((s) => s.cycle == _selectedCycle).toList();

            int totalMonthly = 0;
            for (final s in allSubs) {
              if (s.cycle == 'monthly') {
                totalMonthly += s.amount;
              } else {
                totalMonthly += (s.amount / 12).round();
              }
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
              children: [
                DetailHeader(
                  eyebrow: 'JANGAN KAGET DITAGIH',
                  title: 'Radar langganan',
                  onBack: () => context.pop(),
                ),

                // Subscription Total Card
                Container(
                  padding: const EdgeInsets.all(18),
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
                      const Text(
                        'TOTAL KOMITMEN / BULAN',
                        style: TextStyle(
                          fontFamily: BrutalTokens.fontUi,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: BrutalTokens.ink,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        MoneyFormatter.format(totalMonthly),
                        style: const TextStyle(
                          fontFamily: BrutalTokens.fontNumbers,
                          fontSize: 31,
                          fontWeight: FontWeight.w800,
                          color: BrutalTokens.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        totalMonthly > 0
                            ? 'Sudah dipersiapkan di pos anggaran kamu.'
                            : 'Belum ada tagihan rutin yang terdaftar.',
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
                const SizedBox(height: 22),

                // Filter Tabs: BULANAN vs TAHUNAN
                Row(
                  children: [
                    _buildCycleTab('monthly', 'BULANAN'),
                    _buildCycleTab('yearly', 'TAHUNAN'),
                  ],
                ),
                const SizedBox(height: 14),

                // Empty State if no subscriptions in this cycle
                if (visible.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                    decoration: BoxDecoration(
                      color: BrutalTokens.paper,
                      border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderBase),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Belum ada langganan ${_selectedCycle == "monthly" ? "bulanan" : "tahunan"}.',
                      style: const TextStyle(
                        fontFamily: BrutalTokens.fontUi,
                        fontWeight: FontWeight.w700,
                        color: BrutalTokens.muted,
                      ),
                    ),
                  ),

                // Timeline Rows
                ...visible.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: BrutalTokens.paper,
                      borderRadius: BrutalTokens.radiusZero,
                      border: Border.all(
                        color: BrutalTokens.ink,
                        width: BrutalTokens.borderBase,
                      ),
                      boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: BrutalTokens.ink,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 55,
                            child: Text(
                              'TGL ${item.nextDueDate.split('-').last}',
                              style: const TextStyle(
                                fontFamily: BrutalTokens.fontNumbers,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: BrutalTokens.ink,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              color: BrutalTokens.paper,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontUi,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: BrutalTokens.ink,
                                    ),
                                  ),
                                  Text(
                                    'Jatuh tempo: ${item.nextDueDate}',
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            color: BrutalTokens.paper,
                            child: Text(
                              MoneyFormatter.format(item.amount),
                              style: const TextStyle(
                                fontFamily: BrutalTokens.fontNumbers,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: BrutalTokens.ink,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20, color: BrutalTokens.danger),
                            onPressed: () => subDao.deleteSubscription(item.id),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 18),

                // Button Tambah Langganan
                BrutalButton(
                  text: 'TAMBAH LANGGANAN',
                  variant: BrutalButtonVariant.primary,
                  isFullWidth: true,
                  icon: const Icon(Icons.add, size: 20, color: BrutalTokens.ink),
                  onPressed: () => _showAddSubscriptionDialog(context, ref),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showAddSubscriptionDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final dayCtrl = TextEditingController(text: '1');
    final subDao = ref.read(subscriptionDaoProvider);
    final envRepo = ref.read(envelopeRepositoryProvider);
    String cycle = 'monthly';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          backgroundColor: BrutalTokens.canvas,
          shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
          title: const Text(
            'TAMBAH LANGGANAN',
            style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama (misal: Netflix, Kuota)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Nominal Tagihan (Rp)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dayCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Tanggal Tagih Tiap Bulan (1-31)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => cycle = 'monthly'),
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: cycle == 'monthly' ? BrutalTokens.warn : BrutalTokens.paper,
                            border: Border.all(color: BrutalTokens.ink),
                          ),
                          alignment: Alignment.center,
                          child: const Text('BULANAN', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => cycle = 'yearly'),
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: cycle == 'yearly' ? BrutalTokens.warn : BrutalTokens.paper,
                            border: Border.all(color: BrutalTokens.ink),
                          ),
                          alignment: Alignment.center,
                          child: const Text('TAHUNAN', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                        ),
                      ),
                    ),
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
              text: 'SIMPAN',
              variant: BrutalButtonVariant.primary,
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final amt = int.tryParse(amountCtrl.text.trim()) ?? 0;
                final day = int.tryParse(dayCtrl.text.trim()) ?? 1;

                if (name.isNotEmpty && amt > 0) {
                  final now = DateTime.now();
                  final nextDue = DateHelper.toLocalDateString(DateTime(now.year, now.month, day.clamp(1, 28)));
                  final envelopes = await envRepo.getActiveEnvelopes();
                  final defaultEnv = envelopes.isNotEmpty ? envelopes.first.id : 'unassigned';
                  final nextSeq = await subDao.getNextNotificationSeq();

                  final subDueDate = DateTime(now.year, now.month, day.clamp(1, 28));
                  await subDao.insertSubscription(
                    SubscriptionsTableCompanion.insert(
                      id: IdGenerator.nextId(),
                      name: name,
                      amount: amt,
                      envelopeId: defaultEnv,
                      cycle: cycle,
                      nextDueDate: nextDue,
                      notificationSeq: nextSeq,
                    ),
                  );

                  try {
                    final notif = ref.read(notificationServiceProvider);
                    await notif.scheduleSubscriptionReminder(
                      notificationSeq: nextSeq,
                      name: name,
                      amount: amt,
                      dueDate: subDueDate,
                    );
                  } catch (_) {}

                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleTab(String cycle, String label) {
    final isActive = _selectedCycle == cycle;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCycle = cycle),
        child: Container(
          height: 44,
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
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isActive ? BrutalTokens.paper : BrutalTokens.ink,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
