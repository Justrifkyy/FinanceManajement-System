import 'package:drift/drift.dart';

class BufferEntriesTable extends Table {
  @override
  String get tableName => 'buffer_entries';

  TextColumn get id => text()();
  IntColumn get amount => integer()();
  TextColumn get releaseMonth => text()(); // 'YYYY-MM'
  TextColumn get status => text().withDefault(const Constant('held'))(); // held, released
  TextColumn get holdTransactionId => text()();
  TextColumn get releaseTransactionId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
