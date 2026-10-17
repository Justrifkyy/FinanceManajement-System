import 'package:flutter_test/flutter_test.dart';
import 'package:runway_finance/services/notification_service.dart';

void main() {
  group('NotificationService & Frugal Quotes Tests', () {
    test('Daftar kutipan berhemat memiliki banyak kutipan inspiratif', () {
      expect(NotificationService.frugalQuotes.length, greaterThanOrEqualTo(10));
      for (final quote in NotificationService.frugalQuotes) {
        expect(quote.trim(), isNotEmpty);
      }
    });

    test('getRandomQuote() mengembalikan kutipan valid dari daftar', () {
      final quote = NotificationService.getRandomQuote();
      expect(quote, isNotEmpty);
      expect(NotificationService.frugalQuotes.contains(quote), isTrue);
    });

    test('Kutipan berhemat mengandung kata kunci keuangan & disiplin jajan', () {
      final allText = NotificationService.frugalQuotes.join(' ').toLowerCase();
      expect(allText, contains('berhemat'));
      expect(allText, contains('jajan'));
      expect(allText, contains('runway'));
      expect(allText, contains('uang'));
    });

    test('ID notifikasi terjadwal unik dan tidak saling menimpa', () {
      final reservedIds = [
        NotificationService.idDailyLog,
        NotificationService.idFrugalMotivation,
        NotificationService.idInstantTest,
        NotificationService.idBufferRelease,
      ];

      // Pastikan semua reserved ID unik
      expect(reservedIds.toSet().length, equals(reservedIds.length));

      // Verifikasi formula notifikasi langganan (H-3 = seq*10+1, H-0 = seq*10+2)
      for (int seq = 1; seq <= 50; seq++) {
        final h3Id = seq * 10 + 1;
        final h0Id = seq * 10 + 2;

        expect(reservedIds.contains(h3Id), isFalse);
        expect(reservedIds.contains(h0Id), isFalse);
        expect(h3Id, isNot(equals(h0Id)));
      }
    });
  });
}
