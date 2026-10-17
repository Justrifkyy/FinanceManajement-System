import 'package:flutter_test/flutter_test.dart';
import 'package:runway_finance/domain/buffer.dart';

void main() {
  group('BufferLogic.shouldOfferBuffer', () {
    test('hanya tawarkan jika nominal >= min threshold (default 1.000.000)', () {
      expect(BufferLogic.shouldOfferBuffer(incomeAmount: 999999), isFalse);
      expect(BufferLogic.shouldOfferBuffer(incomeAmount: 1000000), isTrue);
      expect(BufferLogic.shouldOfferBuffer(incomeAmount: 3000000), isTrue);
    });
  });

  group('BufferLogic.calculateSuggestedAmount', () {
    test('default 1/3 dari pemasukan jika avgMonthlyNeeds tidak tersedia', () {
      expect(BufferLogic.calculateSuggestedAmount(incomeAmount: 3000000), 1000000);
    });

    test('mengambil yang lebih kecil antara 1/3 pemasukan dan avgMonthlyNeeds', () {
      // 1/3 dari 6 jt = 2 jt. Avg monthly needs 1.5 jt -> pilih 1.5 jt
      expect(
        BufferLogic.calculateSuggestedAmount(
          incomeAmount: 6000000,
          avgMonthlyNeeds: 1500000,
        ),
        1500000,
      );

      // 1/3 dari 3 jt = 1 jt. Avg monthly needs 2 jt -> pilih 1 jt
      expect(
        BufferLogic.calculateSuggestedAmount(
          incomeAmount: 3000000,
          avgMonthlyNeeds: 2000000,
        ),
        1000000,
      );
    });
  });

  group('BufferLogic.isDueForRelease', () {
    test('jatuh tempo jika releaseMonth <= currentMonth', () {
      expect(
        BufferLogic.isDueForRelease(
          releaseMonth: '2026-10',
          currentMonth: '2026-10',
        ),
        isTrue,
      );

      // Bulan lalu tertinggal belum dicairkan (catch-up)
      expect(
        BufferLogic.isDueForRelease(
          releaseMonth: '2026-09',
          currentMonth: '2026-10',
        ),
        isTrue,
      );

      // Belum jatuh tempo untuk bulan depan
      expect(
        BufferLogic.isDueForRelease(
          releaseMonth: '2026-11',
          currentMonth: '2026-10',
        ),
        isFalse,
      );
    });
  });
}
