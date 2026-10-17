import 'package:drift/drift.dart';

class EnvelopesTable extends Table {
  @override
  String get tableName => 'envelopes';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()(); // unassigned, buffer, needs, wants, pay_yourself_first
  TextColumn get icon => text().nullable()();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isPaused => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
