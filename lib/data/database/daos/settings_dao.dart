import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/app_settings_table.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [AppSettingsTable])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<String?> getValue(String key) async {
    final query = select(appSettingsTable)..where((t) => t.key.equals(key));
    final row = await query.getSingleOrNull();
    return row?.value;
  }

  Stream<String?> watchValue(String key) {
    final query = select(appSettingsTable)..where((t) => t.key.equals(key));
    return query.watchSingleOrNull().map((row) => row?.value);
  }

  Future<void> setValue(String key, String value) async {
    await into(appSettingsTable).insertOnConflictUpdate(
      AppSettingsTableCompanion.insert(
        key: key,
        value: value,
      ),
    );
  }

  Future<int> getInt(String key, {int defaultValue = 0}) async {
    final val = await getValue(key);
    if (val == null) return defaultValue;
    return int.tryParse(val) ?? defaultValue;
  }

  Future<void> setInt(String key, int value) {
    return setValue(key, value.toString());
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final val = await getValue(key);
    if (val == null) return defaultValue;
    return val.toLowerCase() == 'true';
  }

  Future<void> setBool(String key, bool value) {
    return setValue(key, value.toString());
  }
}
