import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/subscriptions_table.dart';
import '../tables/envelopes_table.dart';

part 'subscription_dao.g.dart';

@DriftAccessor(tables: [SubscriptionsTable, EnvelopesTable])
class SubscriptionDao extends DatabaseAccessor<AppDatabase> with _$SubscriptionDaoMixin {
  SubscriptionDao(super.db);

  Future<List<SubscriptionsTableData>> getActiveSubscriptions() {
    return (select(subscriptionsTable)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nextDueDate)]))
        .get();
  }

  Stream<List<SubscriptionsTableData>> watchActiveSubscriptions() {
    return (select(subscriptionsTable)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nextDueDate)]))
        .watch();
  }

  /// Mengambil langganan yang jatuh tempo antara hari ini sampai N hari ke depan
  Future<List<SubscriptionsTableData>> getUpcomingDue(String todayLocalDate, String maxLocalDate) {
    return (select(subscriptionsTable)
          ..where((t) =>
              t.isActive.equals(true) &
              t.nextDueDate.isBetweenValues(todayLocalDate, maxLocalDate))
          ..orderBy([(t) => OrderingTerm.asc(t.nextDueDate)]))
        .get();
  }

  Future<int> insertSubscription(SubscriptionsTableCompanion companion) {
    return into(subscriptionsTable).insert(companion);
  }

  Future<bool> updateSubscription(SubscriptionsTableCompanion companion) {
    return update(subscriptionsTable).replace(companion);
  }

  Future<int> deleteSubscription(String id) {
    return (delete(subscriptionsTable)..where((t) => t.id.equals(id))).go();
  }

  /// Menghasilkan notificationSeq berikutnya yang unik
  Future<int> getNextNotificationSeq() async {
    final query = selectOnly(subscriptionsTable)
      ..addColumns([subscriptionsTable.notificationSeq.max()]);
    final row = await query.getSingle();
    final maxSeq = row.read(subscriptionsTable.notificationSeq.max());
    return (maxSeq ?? 0) + 1;
  }
}
