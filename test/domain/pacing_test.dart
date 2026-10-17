import 'package:flutter_test/flutter_test.dart';
import 'package:runway_finance/domain/pacing.dart';

void main() {
  group('SavingsPacing.calculate', () {
    test('status achieved jika currentAmount >= targetAmount', () {
      final res = SavingsPacing.calculate(
        targetAmount: 5000000,
        currentAmount: 5000000,
        deadlineLocalDate: '2026-12-31',
        todayLocalDate: '2026-10-17',
      );
      expect(res.status, PacingStatus.achieved);
      expect(res.remainingAmount, 0);
    });

    test('status noDeadline jika deadline null atau kosong', () {
      final res = SavingsPacing.calculate(
        targetAmount: 5000000,
        currentAmount: 2000000,
        deadlineLocalDate: null,
        todayLocalDate: '2026-10-17',
      );
      expect(res.status, PacingStatus.noDeadline);
      expect(res.remainingAmount, 3000000);
    });

    test('status overdue jika tenggat sudah lewat dan belum tercapai', () {
      final res = SavingsPacing.calculate(
        targetAmount: 5000000,
        currentAmount: 2000000,
        deadlineLocalDate: '2026-10-10',
        todayLocalDate: '2026-10-17',
      );
      expect(res.status, PacingStatus.overdue);
      expect(res.remainingAmount, 3000000);
    });

    test('menghitung requiredPerDay dan requiredPerMonth dengan benar jika onTrack', () {
      final res = SavingsPacing.calculate(
        targetAmount: 4000000,
        currentAmount: 1000000, // sisa 3.000.000
        deadlineLocalDate: '2026-11-16', // 30 hari ke depan
        todayLocalDate: '2026-10-17',
      );
      expect(res.status, PacingStatus.onTrack);
      expect(res.remainingAmount, 3000000);
      expect(res.daysRemaining, 30);
      expect(res.requiredPerDay, 100000);
      expect(res.requiredPerMonth, 3000000);
    });
  });
}
