import 'package:flutter_test/flutter_test.dart';
import 'package:runway_finance/domain/streak.dart';

void main() {
  group('StreakCalculator.calculateCurrentStreak', () {
    test('streak 0 jika hari ini ada pengeluaran Wants', () {
      final streak = StreakCalculator.calculateCurrentStreak(
        wantsExpenseDates: {'2026-10-17'},
        todayLocalDate: '2026-10-17',
        appStartedLocalDate: '2026-10-01',
      );
      expect(streak, 0);
    });

    test('menghitung hari berturut-turut sampai hari pengeluaran Wants terakhir', () {
      // 17 (hari ini tanpa Wants), 16 (tanpa), 15 (ada pengeluaran Wants) -> streak = 2 (17, 16)
      final streak = StreakCalculator.calculateCurrentStreak(
        wantsExpenseDates: {'2026-10-15'},
        todayLocalDate: '2026-10-17',
        appStartedLocalDate: '2026-10-01',
      );
      expect(streak, 2);
    });

    test('dibatasi oleh appStartedLocalDate jika tidak ada pengeluaran sama sekali', () {
      // Mulai tanggal 15, hari ini tanggal 17 -> hari ke 15, 16, 17 = 3 hari
      final streak = StreakCalculator.calculateCurrentStreak(
        wantsExpenseDates: {},
        todayLocalDate: '2026-10-17',
        appStartedLocalDate: '2026-10-15',
      );
      expect(streak, 3);
    });
  });

  group('StreakCalculator.isNewRecord', () {
    test('true hanya jika current streak melampaui previous longest', () {
      expect(StreakCalculator.isNewRecord(5, 4), isTrue);
      expect(StreakCalculator.isNewRecord(4, 4), isFalse);
      expect(StreakCalculator.isNewRecord(3, 4), isFalse);
      expect(StreakCalculator.isNewRecord(0, 0), isFalse);
    });
  });
}
