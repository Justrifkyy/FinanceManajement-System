import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runway_finance/providers/database_provider.dart';
import 'package:runway_finance/providers/repository_providers.dart';
import 'package:runway_finance/services/backup/auth_service.dart';
import 'package:runway_finance/services/backup/backup_service.dart';
import 'package:runway_finance/services/backup/restore_service.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.watch(databaseProvider);
  final settingsDao = ref.watch(settingsDaoProvider);
  final authService = ref.watch(authServiceProvider);

  return BackupService(
    db,
    settingsDao,
    authService,
  );
});

final restoreServiceProvider = Provider<RestoreService>((ref) {
  final db = ref.watch(databaseProvider);
  return RestoreService(db);
});

final lastBackupTimeProvider = StreamProvider<DateTime?>((ref) {
  final backupService = ref.watch(backupServiceProvider);
  return backupService.watchLastBackupTime();
});
