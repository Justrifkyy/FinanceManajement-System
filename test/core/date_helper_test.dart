import 'package:flutter_test/flutter_test.dart';
import 'package:runway_finance/core/utils/date_helper.dart';

void main() {
  group('DateHelper', () {
    test('toMakassarTime menambahkan offset UTC+8', () {
      final utcTime = DateTime.utc(2026, 10, 17, 0, 0); // 00:00 UTC
      final makassarTime = DateHelper.toMakassarTime(utcTime);
      expect(makassarTime.hour, 8);
    });

    test('toLocalDateString menghasilkan format YYYY-MM-DD', () {
      final utcTime = DateTime.utc(2026, 10, 17, 2, 0);
      final dateStr = DateHelper.toLocalDateString(utcTime);
      expect(dateStr, '2026-10-17');
    });

    test('toReleaseMonthString menghasilkan format YYYY-MM', () {
      final utcTime = DateTime.utc(2026, 10, 17, 2, 0);
      final monthStr = DateHelper.toReleaseMonthString(utcTime);
      expect(monthStr, '2026-10');
    });
  });
}
