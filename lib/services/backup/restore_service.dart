import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:runway_finance/core/constants/app_constants.dart';
import 'package:runway_finance/data/database/app_database.dart';

class RestoreResult {
  final bool isSuccess;
  final String? message;

  const RestoreResult({
    required this.isSuccess,
    this.message,
  });
}

class RestoreService {
  final AppDatabase _db;

  RestoreService(this._db);

  /// Validasi apakah header file adalah file SQLite valid
  bool _isValidSqliteHeader(List<int> bytes) {
    if (bytes.length < 16) return false;
    const header = [0x53, 0x51, 0x4c, 0x69, 0x74, 0x65, 0x20, 0x66, 0x6f, 0x72, 0x6d, 0x61, 0x74, 0x20, 0x33, 0x00]; // "SQLite format 3\0"
    for (int i = 0; i < 16; i++) {
      if (bytes[i] != header[i]) return false;
    }
    return true;
  }

  /// Pulihkan database dari file cadangan .db.gz atau .db
  Future<RestoreResult> restoreFromFile(File file) async {
    try {
      if (!await file.exists()) {
        return const RestoreResult(isSuccess: false, message: 'File cadangan tidak ditemukan.');
      }

      final bytes = await file.readAsBytes();
      List<int> sqliteBytes;

      // Cek apakah file terkompresi gzip
      if (file.path.endsWith('.gz') || (bytes.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b)) {
        try {
          sqliteBytes = gzip.decode(bytes);
        } catch (e) {
          return RestoreResult(isSuccess: false, message: 'Gagal mendekompresi cadangan gzip: $e');
        }
      } else {
        sqliteBytes = bytes;
      }

      // Validasi header SQLite
      if (!_isValidSqliteHeader(sqliteBytes)) {
        return const RestoreResult(isSuccess: false, message: 'File bukan cadangan database SQLite yang valid.');
      }

      final appDocDir = await getApplicationDocumentsDirectory();
      final dbFile = File('${appDocDir.path}/${AppConstants.databaseName}');

      // 1. Buat salinan pengaman database saat ini
      if (await dbFile.exists()) {
        final backupSafety = File('${dbFile.path}.pre_restore_bak');
        await dbFile.copy(backupSafety.path);
      }

      // 2. Tulis byte database yang dipulihkan
      await dbFile.writeAsBytes(sqliteBytes, flush: true);

      // Jalankan verifikasi ke database
      try {
        final result = await _db.customSelect('PRAGMA integrity_check').get();
        final check = result.first.data['integrity_check'] as String?;
        if (check != 'ok') {
          // Rollback ke salinan pengaman
          final safety = File('${dbFile.path}.pre_restore_bak');
          if (await safety.exists()) {
            await safety.copy(dbFile.path);
          }
          return const RestoreResult(isSuccess: false, message: 'Integritas database cadangan rusak.');
        }
      } catch (_) {}

      return const RestoreResult(isSuccess: true, message: 'Database berhasil dipulihkan.');
    } catch (e) {
      return RestoreResult(isSuccess: false, message: 'Terjadi kesalahan saat memulihkan: $e');
    }
  }
}
