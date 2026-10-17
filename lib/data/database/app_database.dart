import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:runway_finance/core/constants/app_constants.dart';
import 'package:runway_finance/core/utils/date_helper.dart';
import 'package:runway_finance/core/utils/id_generator.dart';

import 'tables/envelopes_table.dart';
import 'tables/transactions_table.dart';
import 'tables/pending_incomes_table.dart';
import 'tables/buffer_entries_table.dart';
import 'tables/subscriptions_table.dart';
import 'tables/goals_table.dart';
import 'tables/resisted_events_table.dart';
import 'tables/app_settings_table.dart';

import 'daos/envelope_dao.dart';
import 'daos/transaction_dao.dart';
import 'daos/buffer_dao.dart';
import 'daos/subscription_dao.dart';
import 'daos/goal_dao.dart';
import 'daos/settings_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    EnvelopesTable,
    TransactionsTable,
    PendingIncomesTable,
    BufferEntriesTable,
    SubscriptionsTable,
    GoalsTable,
    ResistedEventsTable,
    AppSettingsTable,
  ],
  daos: [
    EnvelopeDao,
    TransactionDao,
    BufferDao,
    SubscriptionDao,
    GoalDao,
    SettingsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: AppConstants.databaseName);
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
        onCreate: (m) async {
          await m.createAll();
          await _seedInitialData();
        },
        onUpgrade: (m, from, to) async {
          // Migrasi skema berversi (schemaVersion)
          // Contoh untuk versi masa depan (v1.5):
          // if (from < 2) {
          //   await m.createTable(assetsTable);
          // }
        },
      );

  Future<void> _seedInitialData() async {
    final now = DateTime.now().toUtc();
    final today = DateHelper.todayLocalDateString();

    // 1. Seed System Envelopes
    await into(envelopesTable).insert(
      EnvelopesTableCompanion.insert(
        id: 'unassigned',
        name: 'Unassigned Funds',
        category: 'unassigned',
        icon: const Value('💼'),
        isSystem: const Value(true),
        createdAt: now,
      ),
    );

    await into(envelopesTable).insert(
      EnvelopesTableCompanion.insert(
        id: 'buffer',
        name: 'Bantalan Bulan Depan',
        category: 'buffer',
        icon: const Value('🛡️'),
        isSystem: const Value(true),
        createdAt: now,
      ),
    );

    // 2. Seed Default Needs Envelopes
    final defaultNeeds = [
      {'name': 'Makan', 'icon': '🍽️'},
      {'name': 'Transport', 'icon': '🛵'},
      {'name': 'Tagihan', 'icon': '⚡'},
    ];

    for (int i = 0; i < defaultNeeds.length; i++) {
      await into(envelopesTable).insert(
        EnvelopesTableCompanion.insert(
          id: IdGenerator.nextId(),
          name: defaultNeeds[i]['name']!,
          category: 'needs',
          icon: Value(defaultNeeds[i]['icon']),
          sortOrder: Value(i + 1),
          createdAt: now,
        ),
      );
    }

    // 3. Seed Default Wants Envelopes
    final defaultWants = [
      {'name': 'Kuota', 'icon': '📶'},
      {'name': 'Top-up Game', 'icon': '🎮'},
      {'name': 'Hiburan', 'icon': '🍿'},
    ];

    for (int i = 0; i < defaultWants.length; i++) {
      await into(envelopesTable).insert(
        EnvelopesTableCompanion.insert(
          id: IdGenerator.nextId(),
          name: defaultWants[i]['name']!,
          category: 'wants',
          icon: Value(defaultWants[i]['icon']),
          sortOrder: Value(i + 1),
          createdAt: now,
        ),
      );
    }

    // 4. Seed Default App Settings
    await into(appSettingsTable).insert(
      AppSettingsTableCompanion.insert(
        key: 'app_started_on',
        value: today,
      ),
    );

    await into(appSettingsTable).insert(
      AppSettingsTableCompanion.insert(
        key: 'longest_streak',
        value: '0',
      ),
    );

    await into(appSettingsTable).insert(
      AppSettingsTableCompanion.insert(
        key: 'onboarding_done',
        value: 'false',
      ),
    );
  }
}
