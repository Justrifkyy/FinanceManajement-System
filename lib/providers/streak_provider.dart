import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/date_helper.dart';
import '../domain/streak.dart';
import 'repository_providers.dart';

class StreakState {
  final int currentStreak;
  final int longestStreak;
  final int resistedCount;
  final List<bool> last7DaysFast; // true jika hari tersebut puasa (tidak ada belanja wants)

  const StreakState({
    required this.currentStreak,
    required this.longestStreak,
    required this.resistedCount,
    required this.last7DaysFast,
  });
}

final streakProvider = StreamProvider<StreakState>((ref) async* {
  final transactionDao = ref.watch(transactionDaoProvider);
  final settingsDao = ref.watch(settingsDaoProvider);

  // Re-run whenever transactions or resisted events update
  await for (final _ in transactionDao.watchRecentTransactions(limit: 1)) {
    final wantsDates = await transactionDao.getWantsExpenseDates();
    final appStartedStr = await settingsDao.getValue('app_started_on') ?? DateHelper.todayLocalDateString();
    final longestStreakStr = await settingsDao.getValue('longest_streak') ?? '0';
    final longestStreak = int.tryParse(longestStreakStr) ?? 0;

    final todayStr = DateHelper.todayLocalDateString();
    final currentStreak = StreakCalculator.calculateCurrentStreak(
      wantsExpenseDates: wantsDates,
      todayLocalDate: todayStr,
      appStartedLocalDate: appStartedStr,
    );

    // Update rekor jika streak baru lebih tinggi
    if (StreakCalculator.isNewRecord(currentStreak, longestStreak)) {
      await settingsDao.setValue('longest_streak', currentStreak.toString());
    }

    // 7 hari terakhir
    final today = DateTime.tryParse(todayStr) ?? DateTime.now();
    final last7Days = <bool>[];
    for (int i = 6; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final dayStr = DateHelper.toLocalDateString(day);
      last7Days.add(!wantsDates.contains(dayStr));
    }

    final resistedCount = await transactionDao.watchResistedEventsCount().first;

    yield StreakState(
      currentStreak: currentStreak,
      longestStreak: currentStreak > longestStreak ? currentStreak : longestStreak,
      resistedCount: resistedCount,
      last7DaysFast: last7Days,
    );
  }
});
