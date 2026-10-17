import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/transactions_table.dart';
import '../tables/envelopes_table.dart';
import '../tables/pending_incomes_table.dart';
import '../tables/resisted_events_table.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [
  TransactionsTable,
  EnvelopesTable,
  PendingIncomesTable,
  ResistedEventsTable,
])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {
  TransactionDao(super.db);

  /// Mengambil transaksi terbaru (hanya yang belum di-soft delete)
  Future<List<TransactionsTableData>> getRecentTransactions({int limit = 50}) {
    return (select(transactionsTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])
          ..limit(limit))
        .get();
  }

  /// Watch transaksi terbaru
  Stream<List<TransactionsTableData>> watchRecentTransactions({int limit = 50}) {
    return (select(transactionsTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])
          ..limit(limit))
        .watch();
  }

  /// Menghitung total pengeluaran (counts_as_spending = true) antara tanggal rentang
  Future<int> getSpendingBetween(String fromLocalDate, String toLocalDate) async {
    final query = selectOnly(transactionsTable)
      ..addColumns([transactionsTable.amount.sum()])
      ..where(
        transactionsTable.type.equals('expense') &
            transactionsTable.countsAsSpending.equals(true) &
            transactionsTable.deletedAt.isNull() &
            transactionsTable.localDate.isBetweenValues(fromLocalDate, toLocalDate),
      );

    final row = await query.getSingle();
    return row.read(transactionsTable.amount.sum()) ?? 0;
  }

  /// Mengambil tanggal transaksi pertama yang tercatat
  Future<String?> getFirstTransactionLocalDate() async {
    final query = (select(transactionsTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.occurredAt)])
          ..limit(1));
    final result = await query.getSingleOrNull();
    return result?.localDate;
  }

  /// Mengambil himpunan tanggal yang memiliki pengeluaran kategori Wants (untuk Puasa Jajan)
  Future<Set<String>> getWantsExpenseDates() async {
    final query = select(transactionsTable).join([
      innerJoin(
        envelopesTable,
        envelopesTable.id.equalsExp(transactionsTable.fromEnvelopeId),
      ),
    ])
      ..where(
        transactionsTable.type.equals('expense') &
            transactionsTable.deletedAt.isNull() &
            envelopesTable.category.equals('wants'),
      );

    final rows = await query.get();
    final dates = <String>{};
    for (final row in rows) {
      final tx = row.readTable(transactionsTable);
      dates.add(tx.localDate);
    }
    return dates;
  }

  /// Catat transaksi baru
  Future<int> insertTransaction(TransactionsTableCompanion companion) {
    return into(transactionsTable).insert(companion);
  }

  /// Soft delete transaksi (deleted_at diisi waktu sekarang)
  Future<int> softDeleteTransaction(String id) {
    return (update(transactionsTable)..where((t) => t.id.equals(id))).write(
      TransactionsTableCompanion(
        deletedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  // --- Uang Di Jalan (Pending Incomes) ---

  /// Catat piutang / invoice baru (Uang di jalan)
  Future<int> insertPendingIncome(PendingIncomesTableCompanion companion) {
    return into(pendingIncomesTable).insert(companion);
  }

  /// Watch semua uang di jalan yang masih berstatus 'pending'
  Stream<List<PendingIncomesTableData>> watchPendingIncomes() {
    return (select(pendingIncomesTable)
          ..where((t) => t.status.equals('pending'))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Watch total nominal uang di jalan yang masih pending
  Stream<int> watchTotalPendingIncome() {
    final query = select(pendingIncomesTable)
      ..where((t) => t.status.equals('pending'));
    return query.watch().map((rows) {
      int sum = 0;
      for (final r in rows) {
        sum += r.amount;
      }
      return sum;
    });
  }

  /// Cairkan uang di jalan -> ubah status jadi 'received' dan link ke ID transaksi
  Future<int> markPendingIncomeReceived({
    required String id,
    required String transactionId,
  }) {
    return (update(pendingIncomesTable)..where((t) => t.id.equals(id))).write(
      PendingIncomesTableCompanion(
        status: const Value('received'),
        receivedTransactionId: Value(transactionId),
      ),
    );
  }

  // --- Puasa Jajan & Menahan Diri (Resisted Events) ---

  /// Catat momen berhasil menahan diri dari godaan jajan
  Future<int> insertResistedEvent(ResistedEventsTableCompanion companion) {
    return into(resistedEventsTable).insert(companion);
  }

  /// Watch total momen menahan diri
  Stream<int> watchResistedEventsCount() {
    final query = select(resistedEventsTable);
    return query.watch().map((rows) => rows.length);
  }

  /// Ambil total nominal uang yang berhasil diselamatkan dari menahan diri
  Stream<int> watchTotalResistedAmount() {
    final query = select(resistedEventsTable);
    return query.watch().map((rows) {
      int sum = 0;
      for (final r in rows) {
        sum += r.amount;
      }
      return sum;
    });
  }
}

