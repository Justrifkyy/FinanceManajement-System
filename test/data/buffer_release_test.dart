import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runway_finance/data/database/app_database.dart';
import 'package:runway_finance/services/buffer_release_service.dart';

void main() {
  late AppDatabase db;
  late BufferReleaseService bufferService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    bufferService = BufferReleaseService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('BufferReleaseService (Idempotency & Rules BR-09)', () {
    test('mencairkan Bantalan yang jatuh tempo dan memindahkan ke Unassigned Funds', () async {
      final now = DateTime.utc(2026, 10, 17);

      // Buat transaksi hold Rp 1.500.000 ke buffer
      await db.transactionDao.insertTransaction(
        TransactionsTableCompanion.insert(
          id: 'tx-hold-1',
          type: 'buffer_hold',
          amount: 1500000,
          occurredAt: DateTime.utc(2026, 9, 20),
          localDate: '2026-09-20',
          fromEnvelopeId: const Value('unassigned'),
          toEnvelopeId: const Value('buffer'),
          createdAt: DateTime.utc(2026, 9, 20),
        ),
      );

      // Buat buffer_entry dengan release_month 2026-10 (jatuh tempo bulan ini)
      await db.bufferDao.insertBufferEntry(
        BufferEntriesTableCompanion.insert(
          id: 'buf-entry-1',
          amount: 1500000,
          releaseMonth: '2026-10',
          holdTransactionId: 'tx-hold-1',
          createdAt: DateTime.utc(2026, 9, 20),
        ),
      );

      // Cek sebelum dicairkan: buffer = 1.500.000, unassigned = -1.500.000
      expect(await db.envelopeDao.getEnvelopeBalance('buffer'), 1500000);
      expect(await db.envelopeDao.getEnvelopeBalance('unassigned'), -1500000);

      // Jalankan pencairan pada Oktober 2026
      final releasedAmount = await bufferService.checkAndReleaseDueBuffers(now: now);
      expect(releasedAmount, 1500000);

      // Cek setelah pencairan: buffer = 0, unassigned = 0 (karena kembali ditransfer ke unassigned)
      expect(await db.envelopeDao.getEnvelopeBalance('buffer'), 0);
      expect(await db.envelopeDao.getEnvelopeBalance('unassigned'), 0);

      // Status buffer_entries harus 'released'
      final entry = await (db.select(db.bufferEntriesTable)..where((t) => t.id.equals('buf-entry-1'))).getSingle();
      expect(entry.status, 'released');
      expect(entry.releaseTransactionId, isNotNull);
    });

    test('Wajib idempoten: dipanggil berulang kali TIDAK mencairkan uang ganda', () async {
      final now = DateTime.utc(2026, 10, 17);

      // Buat entri buffer jatuh tempo
      await db.bufferDao.insertBufferEntry(
        BufferEntriesTableCompanion.insert(
          id: 'buf-entry-idempotent',
          amount: 2000000,
          releaseMonth: '2026-10',
          holdTransactionId: 'tx-hold-dummy',
          createdAt: DateTime.utc(2026, 9, 15),
        ),
      );

      // Panggilan pertama: berhasil cairkan Rp 2.000.000
      final firstRun = await bufferService.checkAndReleaseDueBuffers(now: now);
      expect(firstRun, 2000000);

      // Panggilan kedua (misal app dibuka lagi di hari yang sama): harus 0
      final secondRun = await bufferService.checkAndReleaseDueBuffers(now: now);
      expect(secondRun, 0);

      // Panggilan ketiga: tetap 0
      final thirdRun = await bufferService.checkAndReleaseDueBuffers(now: now);
      expect(thirdRun, 0);

      // Pastikan hanya ada 1 transaksi buffer_release yang dibuat
      final txs = await (db.select(db.transactionsTable)..where((t) => t.bufferEntryId.equals('buf-entry-idempotent'))).get();
      expect(txs.length, 1);
    });

    test('TIDAK mencairkan entri yang belum jatuh tempo (bulan depan)', () async {
      final now = DateTime.utc(2026, 10, 17);

      // Buat entri buffer untuk bulan depan (2026-11)
      await db.bufferDao.insertBufferEntry(
        BufferEntriesTableCompanion.insert(
          id: 'buf-entry-future',
          amount: 3000000,
          releaseMonth: '2026-11',
          holdTransactionId: 'tx-hold-future',
          createdAt: DateTime.utc(2026, 10, 15),
        ),
      );

      // Jalankan pencairan di bulan Oktober
      final released = await bufferService.checkAndReleaseDueBuffers(now: now);
      expect(released, 0);

      // Status tetap 'held'
      final entry = await (db.select(db.bufferEntriesTable)..where((t) => t.id.equals('buf-entry-future'))).getSingle();
      expect(entry.status, 'held');
      expect(entry.releaseTransactionId, isNull);
    });
  });
}
