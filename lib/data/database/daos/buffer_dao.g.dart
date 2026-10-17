// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buffer_dao.dart';

// ignore_for_file: type=lint
mixin _$BufferDaoMixin on DatabaseAccessor<AppDatabase> {
  $BufferEntriesTableTable get bufferEntriesTable =>
      attachedDatabase.bufferEntriesTable;
  $EnvelopesTableTable get envelopesTable => attachedDatabase.envelopesTable;
  $GoalsTableTable get goalsTable => attachedDatabase.goalsTable;
  $PendingIncomesTableTable get pendingIncomesTable =>
      attachedDatabase.pendingIncomesTable;
  $TransactionsTableTable get transactionsTable =>
      attachedDatabase.transactionsTable;
  BufferDaoManager get managers => BufferDaoManager(this);
}

class BufferDaoManager {
  final _$BufferDaoMixin _db;
  BufferDaoManager(this._db);
  $$BufferEntriesTableTableTableManager get bufferEntriesTable =>
      $$BufferEntriesTableTableTableManager(
        _db.attachedDatabase,
        _db.bufferEntriesTable,
      );
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
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(
        _db.attachedDatabase,
        _db.transactionsTable,
      );
}
