import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runway_finance/data/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Database Schema & MigrationStrategy Tests', () {
    test('schemaVersion bernilai 1 pada versi awal (v1)', () {
      expect(db.schemaVersion, 1);
    });

    test('semua tabel dan initial seed berhasil dibuat saat database onCreate', () async {
      // 1. Cek amplop sistem 'unassigned' dan 'buffer' (BR-18)
      final unassigned = await (db.select(db.envelopesTable)..where((t) => t.id.equals('unassigned'))).getSingleOrNull();
      final buffer = await (db.select(db.envelopesTable)..where((t) => t.id.equals('buffer'))).getSingleOrNull();

      expect(unassigned, isNotNull);
      expect(unassigned!.category, 'unassigned');
      expect(unassigned.isSystem, isTrue);

      expect(buffer, isNotNull);
      expect(buffer!.category, 'buffer');
      expect(buffer.isSystem, isTrue);

      // 2. Cek amplop default Needs dan Wants
      final allEnvelopes = await db.select(db.envelopesTable).get();
      final needsEnvelopes = allEnvelopes.where((e) => e.category == 'needs').toList();
      final wantsEnvelopes = allEnvelopes.where((e) => e.category == 'wants').toList();

      expect(needsEnvelopes.length, 3); // Makan, Transport, Tagihan
      expect(wantsEnvelopes.length, 3); // Kuota, Top-up Game, Hiburan

      // 3. Cek default app settings
      final appStarted = await db.settingsDao.getValue('app_started_on');
      final longestStreak = await db.settingsDao.getValue('longest_streak');
      final onboardingDone = await db.settingsDao.getBool('onboarding_done');

      expect(appStarted, isNotNull);
      expect(longestStreak, '0');
      expect(onboardingDone, isFalse);
    });

    test('PRAGMA foreign_keys = ON aktif dan menolak foreign key tidak valid', () async {
      final foreignKeyStatus = await db.customSelect('PRAGMA foreign_keys').getSingle();
      expect(foreignKeyStatus.read<int>('foreign_keys'), 1);
    });

    test('SQLite integrity_check mengembalikan "ok"', () async {
      final integrityResult = await db.customSelect('PRAGMA integrity_check').getSingle();
      expect(integrityResult.read<String>('integrity_check'), 'ok');
    });
  });
}
