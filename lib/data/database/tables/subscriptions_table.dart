import 'package:drift/drift.dart';
import 'envelopes_table.dart';

class SubscriptionsTable extends Table {
  @override
  String get tableName => 'subscriptions';

  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get amount => integer()();
  TextColumn get cycle => text()(); // monthly, yearly
  TextColumn get nextDueDate => text()(); // 'YYYY-MM-DD'
  TextColumn get envelopeId => text().references(EnvelopesTable, #id)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get notificationSeq => integer().unique()();

  @override
  Set<Column> get primaryKey => {id};
}
