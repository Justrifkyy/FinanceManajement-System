import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/goals_table.dart';
import '../tables/transactions_table.dart';

part 'goal_dao.g.dart';

@DriftAccessor(tables: [GoalsTable, TransactionsTable])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin {
  GoalDao(super.db);

  Future<List<GoalsTableData>> getActiveGoals() {
    return (select(goalsTable)
          ..where((t) => t.status.equals('active'))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Stream<List<GoalsTableData>> watchActiveGoals() {
    return (select(goalsTable)
          ..where((t) => t.status.equals('active'))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Menghitung saldo terkumpul sebuah target dari transaksi buku besar (BR-02)
  /// Saldo = (Total goal_deposit) - (Total goal_withdraw)
  Future<int> getGoalBalance(String goalId) async {
    final depositQuery = selectOnly(transactionsTable)
      ..addColumns([transactionsTable.amount.sum()])
      ..where(transactionsTable.goalId.equals(goalId) &
          transactionsTable.type.equals('goal_deposit') &
          transactionsTable.deletedAt.isNull());
    final depositRow = await depositQuery.getSingle();
    final totalDeposit = depositRow.read(transactionsTable.amount.sum()) ?? 0;

    final withdrawQuery = selectOnly(transactionsTable)
      ..addColumns([transactionsTable.amount.sum()])
      ..where(transactionsTable.goalId.equals(goalId) &
          transactionsTable.type.equals('goal_withdraw') &
          transactionsTable.deletedAt.isNull());
    final withdrawRow = await withdrawQuery.getSingle();
    final totalWithdraw = withdrawRow.read(transactionsTable.amount.sum()) ?? 0;

    return totalDeposit - totalWithdraw;
  }

  /// Watch saldo terkumpul sebuah target
  Stream<int> watchGoalBalance(String goalId) {
    final query = select(transactionsTable)
      ..where((t) => t.goalId.equals(goalId) & t.deletedAt.isNull());

    return query.watch().map((txs) {
      int balance = 0;
      for (final tx in txs) {
        if (tx.type == 'goal_deposit') balance += tx.amount;
        if (tx.type == 'goal_withdraw') balance -= tx.amount;
      }
      return balance;
    });
  }

  Future<int> insertGoal(GoalsTableCompanion companion) {
    return into(goalsTable).insert(companion);
  }

  Future<bool> updateGoal(GoalsTableCompanion companion) {
    return update(goalsTable).replace(companion);
  }

  Future<int> deleteGoal(String id) {
    return (delete(goalsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> updateGoalDetails({
    required String id,
    required String name,
    required int targetAmount,
    String? deadline,
  }) async {
    await (update(goalsTable)..where((t) => t.id.equals(id))).write(
      GoalsTableCompanion(
        name: Value(name),
        targetAmount: Value(targetAmount),
        deadline: Value(deadline),
      ),
    );
  }

  Future<void> archiveOrDeleteGoal(String id) async {
    final countQuery = selectOnly(transactionsTable)
      ..addColumns([transactionsTable.id.count()])
      ..where(transactionsTable.goalId.equals(id));
    final count = (await countQuery.getSingle()).read(transactionsTable.id.count()) ?? 0;
    if (count > 0) {
      await (update(goalsTable)..where((t) => t.id.equals(id))).write(
        const GoalsTableCompanion(status: Value('cancelled')),
      );
    } else {
      await (delete(goalsTable)..where((t) => t.id.equals(id))).go();
    }
  }
}
