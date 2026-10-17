import 'package:drift/drift.dart';
import 'envelopes_table.dart';
import 'goals_table.dart';
import 'pending_incomes_table.dart';
import 'buffer_entries_table.dart';

class TransactionsTable extends Table {
  @override
  String get tableName => 'transactions';

  TextColumn get id => text()();
  TextColumn get type => text()(); // income, expense, allocation, transfer, buffer_hold, buffer_release, goal_deposit, goal_withdraw, asset_deposit, asset_withdraw
  IntColumn get amount => integer().customConstraint('NOT NULL CHECK (amount > 0)')();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get localDate => text()(); // 'YYYY-MM-DD'
  @ReferenceName('fromTransactions')
  TextColumn get fromEnvelopeId => text().nullable().references(EnvelopesTable, #id)();

  @ReferenceName('toTransactions')
  TextColumn get toEnvelopeId => text().nullable().references(EnvelopesTable, #id)();
  TextColumn get goalId => text().nullable().references(GoalsTable, #id)();
  TextColumn get assetId => text().nullable()();
  BoolColumn get countsAsSpending => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().nullable()();
  TextColumn get source => text().nullable()();
  TextColumn get pendingIncomeId => text().nullable().references(PendingIncomesTable, #id)();
  TextColumn get bufferEntryId => text().nullable().references(BufferEntriesTable, #id)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
