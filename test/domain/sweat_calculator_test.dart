import 'package:flutter_test/flutter_test.dart';
import 'package:runway_finance/domain/sweat_calculator.dart';

void main() {
  group('SweatCalculator.calculateCostInDays', () {
    test('mengembalikan null jika avgDailySpend null atau <= 0', () {
      expect(
        SweatCalculator.calculateCostInDays(amount: 50000, avgDailySpend: null),
        isNull,
      );
      expect(
        SweatCalculator.calculateCostInDays(amount: 50000, avgDailySpend: 0),
        isNull,
      );
    });

    test('menghitung biaya dalam satuan hari dibulatkan 1 desimal', () {
      // Rp 30.000 dengan avg daily Rp 30.000 = 1.0 hari
      expect(
        SweatCalculator.calculateCostInDays(amount: 30000, avgDailySpend: 30000),
        1.0,
      );

      // Rp 45.000 dengan avg daily Rp 30.000 = 1.5 hari
      expect(
        SweatCalculator.calculateCostInDays(amount: 45000, avgDailySpend: 30000),
        1.5,
      );

      // Rp 10.000 dengan avg daily Rp 100.000 = 0.1 hari
      expect(
        SweatCalculator.calculateCostInDays(amount: 10000, avgDailySpend: 100000),
        0.1,
      );
    });
  });

  group('SweatCalculator.shouldShowPrompt', () {
    test('tidak menampilkan prompt jika cost < 0.1 hari', () {
      expect(SweatCalculator.shouldShowPrompt(0.05), isFalse);
      expect(SweatCalculator.shouldShowPrompt(null), isFalse);
    });

    test('menampilkan prompt jika cost >= 0.1 hari', () {
      expect(SweatCalculator.shouldShowPrompt(0.1), isTrue);
      expect(SweatCalculator.shouldShowPrompt(1.2), isTrue);
    });
  });
}
