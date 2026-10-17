// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'envelope_dao.dart';

// ignore_for_file: type=lint
mixin _$EnvelopeDaoMixin on DatabaseAccessor<AppDatabase> {
  $EnvelopesTableTable get envelopesTable => attachedDatabase.envelopesTable;
  $GoalsTableTable get goalsTable => attachedDatabase.goalsTable;
  $PendingIncomesTableTable get pendingIncomesTable =>
      attachedDatabase.pendingIncomesTable;
  $BufferEntriesTableTable get bufferEntriesTable =>
      attachedDatabase.bufferEntriesTable;
  $TransactionsTableTable get transactionsTable =>
      attachedDatabase.transactionsTable;
  EnvelopeDaoManager get managers => EnvelopeDaoManager(this);
}

class EnvelopeDaoManager {
  final _$EnvelopeDaoMixin _db;
  EnvelopeDaoManager(this._db);
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
}
