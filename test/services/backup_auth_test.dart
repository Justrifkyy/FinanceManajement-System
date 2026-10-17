import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runway_finance/data/database/app_database.dart';
import 'package:runway_finance/data/database/daos/settings_dao.dart';
import 'package:runway_finance/services/backup/auth_service.dart';
import 'package:runway_finance/services/backup/restore_service.dart';

void main() {
  late AppDatabase db;
  late SettingsDao settingsDao;
  late AuthService authService;
  late RestoreService restoreService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    settingsDao = db.settingsDao;
    authService = AuthService(settingsDao);
    restoreService = RestoreService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('AuthService Tests', () {
    test('Pengguna awal adalah Guest (Tamu)', () async {
      final user = await authService.getCurrentUser();
      expect(user.isLoggedIn, isFalse);
      expect(user.authType, 'guest');
      expect(user.email, isEmpty);
    });

    test('Login dengan Email menyimpan email & nama ke settingsDao', () async {
      final user = await authService.signInWithEmail(
        email: 'pejuang@runway.id',
        name: 'Pejuang Runway',
      );

      expect(user.isLoggedIn, isTrue);
      expect(user.email, 'pejuang@runway.id');
      expect(user.name, 'Pejuang Runway');
      expect(user.authType, 'email');

      // Verifikasi tersimpan di database
      final savedUser = await authService.getCurrentUser();
      expect(savedUser.isLoggedIn, isTrue);
      expect(savedUser.email, 'pejuang@runway.id');
      expect(savedUser.name, 'Pejuang Runway');
    });

    test('SignOut menghapus sesi dan kembali ke status Guest', () async {
      await authService.signInWithEmail(
        email: 'pejuang@runway.id',
        name: 'Pejuang Runway',
      );

      await authService.signOut();

      final user = await authService.getCurrentUser();
      expect(user.isLoggedIn, isFalse);
      expect(user.authType, 'guest');
      expect(user.email, isEmpty);
    });
  });

  group('RestoreService Validation Tests', () {
    test('Menolak file cadangan yang corrupt / bukan gzip valid', () async {
      final tempDir = Directory.systemTemp.createTempSync('restore_test');
      final corruptedFile = File('${tempDir.path}/fake.db.gz');
      await corruptedFile.writeAsString('Bukan file gzip dan bukan sqlite');

      final result = await restoreService.restoreFromFile(corruptedFile);
      expect(result.isSuccess, isFalse);
      expect(result.message, contains('Gagal mendekompresi'));

      tempDir.deleteSync(recursive: true);
    });

    test('Menolak file gzip yang isinya bukan format SQLite', () async {
      final tempDir = Directory.systemTemp.createTempSync('restore_test2');
      final fakeGzFile = File('${tempDir.path}/fake_text.db.gz');
      // Tulis file gzip berisi teks acak, bukan header 'SQLite format 3'
      final compressedBytes = gzip.encode('Hello World'.codeUnits);
      await fakeGzFile.writeAsBytes(compressedBytes);

      final result = await restoreService.restoreFromFile(fakeGzFile);
      expect(result.isSuccess, isFalse);
      expect(result.message, contains('bukan cadangan database SQLite yang valid'));

      tempDir.deleteSync(recursive: true);
    });
  });
}
