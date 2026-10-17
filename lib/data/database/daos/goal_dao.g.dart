// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_dao.dart';

// ignore_for_file: type=lint
mixin _$GoalDaoMixin on DatabaseAccessor<AppDatabase> {
  $GoalsTableTable get goalsTable => attachedDatabase.goalsTable;
  $EnvelopesTableTable get envelopesTable => attachedDatabase.envelopesTable;
  $PendingIncomesTableTable get pendingIncomesTable =>
      attachedDatabase.pendingIncomesTable;
  $BufferEntriesTableTable get bufferEntriesTable =>
      attachedDatabase.bufferEntriesTable;
  $TransactionsTableTable get transactionsTable =>
      attachedDatabase.transactionsTable;
  GoalDaoManager get managers => GoalDaoManager(this);
}

class GoalDaoManager {
  final _$GoalDaoMixin _db;
  GoalDaoManager(this._db);
  $$GoalsTableTableTableManager get goalsTable =>
      $$GoalsTableTableTableManager(_db.attachedDatabase, _db.goalsTable);
  $$EnvelopesTableTableTableManager get envelopesTable =>
      $$EnvelopesTableTableTableManager(
        _db.attachedDatabase,
        _db.envelopesTable,
      );
  $$PendingIncomesTableTableTableManager get pendingIncomesTable =>
      $$PendingIncomesTableTableTableManager(
        _db.attachedDatabase,
        _db.pendingIncomesTable,
      );
  $$BufferEntriesTableTableTableManager get bufferEntriesTable =>
      $$BufferEntriesTableTableTableManager(
        _db.attachedDatabase,
        _db.bufferEntriesTable,
      );
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(
        _db.attachedDatabase,
        _db.transactionsTable,
      );
}
