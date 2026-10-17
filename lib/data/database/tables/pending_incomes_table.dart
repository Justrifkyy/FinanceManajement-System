import 'package:drift/drift.dart';

class PendingIncomesTable extends Table {
  @override
  String get tableName => 'pending_incomes';

  TextColumn get id => text()();
  IntColumn get amount => integer()();
  TextColumn get client => text().nullable()();
  TextColumn get expectedDate => text().nullable()(); // 'YYYY-MM-DD'
  TextColumn get status => text()(); // pending, received, cancelled
  TextColumn get receivedTransactionId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
