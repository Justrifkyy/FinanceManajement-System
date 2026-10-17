// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_dao.dart';

// ignore_for_file: type=lint
mixin _$SubscriptionDaoMixin on DatabaseAccessor<AppDatabase> {
  $EnvelopesTableTable get envelopesTable => attachedDatabase.envelopesTable;
  $SubscriptionsTableTable get subscriptionsTable =>
      attachedDatabase.subscriptionsTable;
  SubscriptionDaoManager get managers => SubscriptionDaoManager(this);
}

class SubscriptionDaoManager {
  final _$SubscriptionDaoMixin _db;
  SubscriptionDaoManager(this._db);
  $$EnvelopesTableTableTableManager get envelopesTable =>
      $$EnvelopesTableTableTableManager(
        _db.attachedDatabase,
        _db.envelopesTable,
      );
  $$SubscriptionsTableTableTableManager get subscriptionsTable =>
      $$SubscriptionsTableTableTableManager(
        _db.attachedDatabase,
        _db.subscriptionsTable,
      );
}
