import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'data/database/app_database.dart';
import 'providers/database_provider.dart';
import 'services/buffer_release_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi locale data bahasa Indonesia untuk DateFormat
  await initializeDateFormatting('id_ID', null);

  // Inisialisasi koneksi database Drift (SQLite lokal)
  final database = AppDatabase();

  // Jalankan pencairan Bantalan Bulan Depan (idempoten) saat aplikasi pertama kali dibuka (cold start)
  final bufferReleaseService = BufferReleaseService(database);
  await bufferReleaseService.checkAndReleaseDueBuffers();

  // Inisialisasi notifikasi lokal & jadwalkan pengingat evaluasi serta motivasi berhemat acak
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.rescheduleAll(database);

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: const RunwayFinanceApp(),
    ),
  );
}
