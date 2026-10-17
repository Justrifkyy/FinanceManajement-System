import 'package:flutter_test/flutter_test.dart';
import 'package:runway_finance/domain/runway.dart';

void main() {
  group('RunwayCalculator.calculateAvgDailySpend', () {
    test('mengembalikan null jika transaksi baru berjalan kurang dari minDays (7 hari)', () {
      final spend = RunwayCalculator.calculateAvgDailySpend(
        totalSpending30Days: 1400000,
        daysSinceFirstTransaction: 5,
      );
      expect(spend, isNull);
    });

    test('membagi dengan jumlah hari efektif jika antara 7 dan 30 hari', () {
      final spend = RunwayCalculator.calculateAvgDailySpend(
        totalSpending30Days: 700000,
        daysSinceFirstTransaction: 10,
      );
      expect(spend, 70000);
    });

    test('membagi dengan 30 hari jika riwayat sudah >= 30 hari', () {
      final spend = RunwayCalculator.calculateAvgDailySpend(
        totalSpending30Days: 3000000,
        daysSinceFirstTransaction: 45,
      );
      expect(spend, 100000);
    });
  });

  group('RunwayCalculator.calculateRunwayDays', () {
    test('mengembalikan null jika avgDailySpend null atau 0 (mencegah pembagian dengan nol)', () {
      expect(
        RunwayCalculator.calculateRunwayDays(liquidCash: 5000000, avgDailySpend: null),
        isNull,
      );
      expect(
        RunwayCalculator.calculateRunwayDays(liquidCash: 5000000, avgDailySpend: 0),
        isNull,
      );
    });

    test('mengembalikan 0 jika liquidCash <= 0', () {
      expect(
        RunwayCalculator.calculateRunwayDays(liquidCash: 0, avgDailySpend: 100000),
        0,
      );
      expect(
        RunwayCalculator.calculateRunwayDays(liquidCash: -50000, avgDailySpend: 100000),
        0,
      );
    });

    test('menghitung floor dari liquidCash / avgDailySpend', () {
      expect(
        RunwayCalculator.calculateRunwayDays(liquidCash: 3500000, avgDailySpend: 100000),
        35,
      );
      expect(
        RunwayCalculator.calculateRunwayDays(liquidCash: 190000, avgDailySpend: 100000),
        1,
      );
    });
  });

  group('RunwayCalculator.determineHealthStatus', () {
    test('mengembalikan noData jika runway null', () {
      expect(RunwayCalculator.determineHealthStatus(null), HealthStatus.noData);
    });

    test('mengembalikan safe jika runway > 30', () {
      expect(RunwayCalculator.determineHealthStatus(31), HealthStatus.safe);
      expect(RunwayCalculator.determineHealthStatus(100), HealthStatus.safe);
    });

    test('mengembalikan warning jika 15 <= runway <= 30', () {
      expect(RunwayCalculator.determineHealthStatus(30), HealthStatus.warning);
      expect(RunwayCalculator.determineHealthStatus(15), HealthStatus.warning);
      expect(RunwayCalculator.determineHealthStatus(20), HealthStatus.warning);
    });

    test('mengembalikan danger jika runway < 15', () {
      expect(RunwayCalculator.determineHealthStatus(14), HealthStatus.danger);
      expect(RunwayCalculator.determineHealthStatus(0), HealthStatus.danger);
    });
  });
}
