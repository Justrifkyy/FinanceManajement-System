// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_dao.dart';

// ignore_for_file: type=lint
mixin _$TransactionDaoMixin on DatabaseAccessor<AppDatabase> {
  $EnvelopesTableTable get envelopesTable => attachedDatabase.envelopesTable;
  $GoalsTableTable get goalsTable => attachedDatabase.goalsTable;
  $PendingIncomesTableTable get pendingIncomesTable =>
      attachedDatabase.pendingIncomesTable;
  $BufferEntriesTableTable get bufferEntriesTable =>
      attachedDatabase.bufferEntriesTable;
  $TransactionsTableTable get transactionsTable =>
      attachedDatabase.transactionsTable;
  $ResistedEventsTableTable get resistedEventsTable =>
      attachedDatabase.resistedEventsTable;
  TransactionDaoManager get managers => TransactionDaoManager(this);
}

class TransactionDaoManager {
  final _$TransactionDaoMixin _db;
  TransactionDaoManager(this._db);
  $$EnvelopesTableTableTableManager get envelopesTable =>
      $$EnvelopesTableTableTableManager(
        _db.attachedDatabase,
        _db.envelopesTable,
      );
  $$GoalsTableTableTableManager get goalsTable =>
      $$GoalsTableTableTableManager(_db.attachedDatabase, _db.goalsTable);
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
  $$ResistedEventsTableTableTableManager get resistedEventsTable =>
      $$ResistedEventsTableTableTableManager(
        _db.attachedDatabase,
        _db.resistedEventsTable,
      );
}
