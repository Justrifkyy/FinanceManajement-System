import 'package:drift/drift.dart';

class GoalsTable extends Table {
  @override
  String get tableName => 'goals';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // goal, emergency_fund
  IntColumn get targetAmount => integer()();
  TextColumn get deadline => text().nullable()(); // 'YYYY-MM-DD'
  TextColumn get status => text()(); // active, achieved, paused
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
