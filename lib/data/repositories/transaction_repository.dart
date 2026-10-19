import 'package:drift/drift.dart';
import '../../domain/entities/transaction_entity.dart';
import '../database/app_database.dart';
import '../database/daos/transaction_dao.dart';

class TransactionRepository {
  final TransactionDao _transactionDao;

  TransactionRepository(this._transactionDao);

  Future<List<TransactionEntity>> getRecentTransactions({int limit = 50}) async {
    final rows = await _transactionDao.getRecentTransactions(limit: limit);
    return rows.map(_mapToEntity).toList();
  }

  Stream<List<TransactionEntity>> watchRecentTransactions({int limit = 50}) {
    return _transactionDao.watchRecentTransactions(limit: limit).map(
          (rows) => rows.map(_mapToEntity).toList(),
        );
  }

  Future<int> getSpendingBetween(String fromLocalDate, String toLocalDate) {
    return _transactionDao.getSpendingBetween(fromLocalDate, toLocalDate);
  }

  Future<String?> getFirstTransactionLocalDate() {
    return _transactionDao.getFirstTransactionLocalDate();
  }

  Future<Set<String>> getWantsExpenseDates() {
    return _transactionDao.getWantsExpenseDates();
  }

  Future<int> recordTransaction({
    required String id,
    required TransactionType type,
    required int amount,
    required DateTime occurredAt,
    required String localDate,
    String? fromEnvelopeId,
    String? toEnvelopeId,
    String? goalId,
    String? assetId,
    bool countsAsSpending = false,
    String? note,
    String? source,
    String? pendingIncomeId,
    String? bufferEntryId,
  }) {
    final now = DateTime.now().toUtc();
    return _transactionDao.insertTransaction(
      TransactionsTableCompanion.insert(
        id: id,
        type: type.value,
        amount: amount,
        occurredAt: occurredAt.toUtc(),
        localDate: localDate,
        fromEnvelopeId: Value(fromEnvelopeId),
        toEnvelopeId: Value(toEnvelopeId),
        goalId: Value(goalId),
        assetId: Value(assetId),
        countsAsSpending: Value(countsAsSpending),
        note: Value(note),
        source: Value(source),
        pendingIncomeId: Value(pendingIncomeId),
        bufferEntryId: Value(bufferEntryId),
        createdAt: now,
      ),
    );
  }

  Future<int> deleteTransaction(String id) {
    return _transactionDao.softDeleteTransaction(id);
  }

  // --- Uang Di Jalan (Pending Incomes) ---

  Future<int> recordPendingIncome({
    required String id,
    required int amount,
    String? client,
    String? expectedDate,
  }) {
    return _transactionDao.insertPendingIncome(
      PendingIncomesTableCompanion.insert(
        id: id,
        amount: amount,
        client: Value(client),
        expectedDate: Value(expectedDate),
        status: 'pending',
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  Stream<List<PendingIncomesTableData>> watchPendingIncomes() {
    return _transactionDao.watchPendingIncomes();
  }

  Stream<int> watchTotalPendingIncome() {
    return _transactionDao.watchTotalPendingIncome();
  }

  Future<void> markPendingIncomeReceived({
    required String pendingIncomeId,
    required int amount,
    required String toEnvelopeId,
    String? note,
  }) async {
    final now = DateTime.now();
    final localDate = now.toIso8601String().substring(0, 10);
    final txId = DateTime.now().millisecondsSinceEpoch.toString();

    await _transactionDao.attachedDatabase.transaction(() async {
      await recordTransaction(
        id: txId,
        type: TransactionType.income,
        amount: amount,
        occurredAt: now,
        localDate: localDate,
        toEnvelopeId: toEnvelopeId,
        pendingIncomeId: pendingIncomeId,
        note: note,
      );
      await _transactionDao.markPendingIncomeReceived(
        id: pendingIncomeId,
        transactionId: txId,
      );
    });
  }

  // --- Momen Menahan Diri (Resisted Events) ---

  Future<int> recordResistedEvent({
    required String id,
    required int amount,
    required DateTime occurredAt,
    required String localDate,
  }) {
    return _transactionDao.insertResistedEvent(
      ResistedEventsTableCompanion.insert(
        id: id,
        amount: amount,
        occurredAt: occurredAt.toUtc(),
        localDate: localDate,
      ),
    );
  }

  Stream<int> watchResistedEventsCount() {
    return _transactionDao.watchResistedEventsCount();
  }

  Stream<int> watchTotalResistedAmount() {
    return _transactionDao.watchTotalResistedAmount();
  }

  Stream<List<ResistedEventsTableData>> watchAllResistedEvents() {
    return _transactionDao.watchAllResistedEvents();
  }

  static TransactionEntity _mapToEntity(TransactionsTableData row) {
    return TransactionEntity(
      id: row.id,
      type: TransactionTypeExtension.fromString(row.type),
      amount: row.amount,
      occurredAt: row.occurredAt,
      localDate: row.localDate,
      fromEnvelopeId: row.fromEnvelopeId,
      toEnvelopeId: row.toEnvelopeId,
      goalId: row.goalId,
      assetId: row.assetId,
      countsAsSpending: row.countsAsSpending,
      note: row.note,
      source: row.source,
      pendingIncomeId: row.pendingIncomeId,
      bufferEntryId: row.bufferEntryId,
      deletedAt: row.deletedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
