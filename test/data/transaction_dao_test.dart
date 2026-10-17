import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runway_finance/data/database/app_database.dart';
import 'package:runway_finance/data/database/daos/envelope_dao.dart';
import 'package:runway_finance/data/database/daos/transaction_dao.dart';

void main() {
  late AppDatabase db;
  late EnvelopeDao envelopeDao;
  late TransactionDao transactionDao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    envelopeDao = db.envelopeDao;
    transactionDao = db.transactionDao;
  });

  tearDown(() async {
    await db.close();
  });

  group('EnvelopeDao & TransactionDao (Ledger Balance Calculation)', () {
    test('saldo diturunkan dari transaksi (BR-02)', () async {
      final now = DateTime.now().toUtc();

      // Tambah transaksi pemasukan ke 'unassigned' (Rp 5.000.000)
      await transactionDao.insertTransaction(
        TransactionsTableCompanion.insert(
          id: 'tx-1',
          type: 'income',
          amount: 5000000,
          occurredAt: now,
          localDate: '2026-10-17',
          toEnvelopeId: const Value('unassigned'),
          createdAt: now,
        ),
      );

      // Cek saldo unassigned harus 5.000.000
      var unassignedBalance = await envelopeDao.getEnvelopeBalance('unassigned');
      expect(unassignedBalance, 5000000);

      // Pindahkan Rp 2.000.000 dari unassigned ke amplop sistem buffer
      await transactionDao.insertTransaction(
        TransactionsTableCompanion.insert(
          id: 'tx-2',
          type: 'buffer_hold',
          amount: 2000000,
          occurredAt: now,
          localDate: '2026-10-17',
          fromEnvelopeId: const Value('unassigned'),
          toEnvelopeId: const Value('buffer'),
          createdAt: now,
        ),
      );

      // Cek saldo unassigned berkurang jadi 3.000.000 dan buffer bertambah jadi 2.000.000
      unassignedBalance = await envelopeDao.getEnvelopeBalance('unassigned');
      final bufferBalance = await envelopeDao.getEnvelopeBalance('buffer');
      expect(unassignedBalance, 3000000);
      expect(bufferBalance, 2000000);
    });

    test('transaksi yang di-soft-delete tidak dihitung dalam saldo', () async {
      final now = DateTime.now().toUtc();

      // Masuk Rp 1.000.000
      await transactionDao.insertTransaction(
        TransactionsTableCompanion.insert(
          id: 'tx-del-test',
          type: 'income',
          amount: 1000000,
          occurredAt: now,
          localDate: '2026-10-17',
          toEnvelopeId: const Value('unassigned'),
          createdAt: now,
        ),
      );

      expect(await envelopeDao.getEnvelopeBalance('unassigned'), 1000000);

      // Soft delete transaksi
      await transactionDao.softDeleteTransaction('tx-del-test');

      // Saldo unassigned harus kembali 0
      expect(await envelopeDao.getEnvelopeBalance('unassigned'), 0);
    });
  });
}
