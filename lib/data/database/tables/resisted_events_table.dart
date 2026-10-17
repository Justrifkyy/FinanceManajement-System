import 'package:drift/drift.dart';

class ResistedEventsTable extends Table {
  @override
  String get tableName => 'resisted_events';

  TextColumn get id => text()();
  IntColumn get amount => integer()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get localDate => text()(); // 'YYYY-MM-DD'

  @override
  Set<Column> get primaryKey => {id};
}
