import 'package:flutter_test/flutter_test.dart';
import 'package:runway_finance/core/utils/money_formatter.dart';

void main() {
  group('MoneyFormatter', () {
    test('format integer Rupiah dengan pemisah ribuan titik', () {
      expect(MoneyFormatter.format(1500000), contains('1.500.000'));
      expect(MoneyFormatter.format(0), contains('0'));
    });

    test('formatWithoutSymbol hanya menghasilkan angka dan titik', () {
      expect(MoneyFormatter.formatWithoutSymbol(1500000), '1.500.000');
    });

    test('parse membersihkan simbol dan mengembalikan int Rupiah', () {
      expect(MoneyFormatter.parse('Rp 1.500.000'), 1500000);
      expect(MoneyFormatter.parse('1.500.000'), 1500000);
      expect(MoneyFormatter.parse('abc'), 0);
      expect(MoneyFormatter.parse(''), 0);
    });
  });
}
