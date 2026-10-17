import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:runway_finance/core/constants/app_constants.dart';
import 'package:runway_finance/data/database/app_database.dart';
import 'package:runway_finance/data/database/daos/settings_dao.dart';
import 'package:share_plus/share_plus.dart';
import 'auth_service.dart';
import 'drive_client.dart';

class BackupResult {
  final bool isSuccess;
  final String? driveFileId;
  final String localPath;
  final int fileSizeBytes;
  final DateTime timestamp;
  final String? errorMessage;

  const BackupResult({
    required this.isSuccess,
    this.driveFileId,
    required this.localPath,
    required this.fileSizeBytes,
    required this.timestamp,
    this.errorMessage,
  });
}

class BackupService {
  final AppDatabase _db;
  final SettingsDao _settingsDao;
  final AuthService _authService;
  late final DriveClient _driveClient;

  BackupService(
    this._db,
    this._settingsDao,
    this._authService,
  ) {
    _driveClient = DriveClient(_authService);
  }

  DriveClient get driveClient => _driveClient;

  /// Buat snapshot database SQLite lokal yang aman dan dikompres gzip
  Future<File> createLocalSnapshot() async {
    final tempDir = await getTemporaryDirectory();
    final now = DateTime.now();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(now);
    final snapshotPath = '${tempDir.path}/runway_snapshot_$timestamp.db';
    final backupGzPath = '${tempDir.path}/runway_backup_$timestamp.db.gz';

    // 1. Eksekusi SQLite VACUUM INTO (snapshot konsisten saat database terbuka)
    bool vacuumSuccess = false;
    try {
      // Hapus file snapshot lama jika ada
      final oldFile = File(snapshotPath);
      if (await oldFile.exists()) await oldFile.delete();

      await _db.customStatement("VACUUM INTO '$snapshotPath'");
      vacuumSuccess = await File(snapshotPath).exists();
    } catch (_) {
      vacuumSuccess = false;
    }

    // Fallback: Jika VACUUM INTO tidak didukung engine, salin file SQLite langsung
    if (!vacuumSuccess) {
      final appDocDir = await getApplicationDocumentsDirectory();
      final dbFile = File('${appDocDir.path}/${AppConstants.databaseName}');
      if (await dbFile.exists()) {
        await dbFile.copy(snapshotPath);
      } else {
        throw Exception('File database lokal tidak ditemukan untuk dicadangkan.');
      }
    }

    // 2. Kompres file snapshot dengan gzip
    final rawBytes = await File(snapshotPath).readAsBytes();
    final compressedBytes = gzip.encode(rawBytes);
    final gzFile = File(backupGzPath);
    await gzFile.writeAsBytes(compressedBytes);

    // Hapus snapshot mentah untuk hemat penyimpanan
    try {
      await File(snapshotPath).delete();
    } catch (_) {}

    // 3. Simpan salinan ke folder dokumen aplikasi 'backups/'
    final appDocDir = await getApplicationDocumentsDirectory();
    final backupFolder = Directory('${appDocDir.path}/backups');
    if (!await backupFolder.exists()) {
      await backupFolder.create(recursive: true);
    }
    final permanentBackup = await gzFile.copy('${backupFolder.path}/runway_backup_$timestamp.db.gz');

    return permanentBackup;
  }

  /// Jalankan pencadangan sekarang (ke Google Drive jika akun Google terhubung, dan simpan lokal)
  Future<BackupResult> backupNow() async {
    final now = DateTime.now();
    try {
      final gzFile = await createLocalSnapshot();
      final user = await _authService.getCurrentUser();
      String? driveFileId;

      // Jika terhubung dengan Google, upload ke Google Drive
      if (user.authType == 'google') {
        try {
          final fileName = 'runway_backup_${DateFormat('yyyyMMdd_HHmmss').format(now)}.db.gz';
          driveFileId = await _driveClient.uploadBackup(gzFile, fileName);
        } catch (e) {
          // Tetap lanjut agar backup lokal berhasil dicatat
        }
      }

      await _settingsDao.setValue('last_backup_at', now.toIso8601String());
      await _settingsDao.setValue('last_backup_status', 'success');

      return BackupResult(
        isSuccess: true,
        driveFileId: driveFileId,
        localPath: gzFile.path,
        fileSizeBytes: gzFile.lengthSync(),
        timestamp: now,
      );
    } catch (e) {
      await _settingsDao.setValue('last_backup_status', 'failed');
      return BackupResult(
        isSuccess: false,
        localPath: '',
        fileSizeBytes: 0,
        timestamp: now,
        errorMessage: e.toString(),
      );
    }
  }

  /// Ekspor dan bagikan file cadangan ke Email (Gmail) atau aplikasi lain
  Future<void> shareBackupFile() async {
    final gzFile = await createLocalSnapshot();
    final user = await _authService.getCurrentUser();
    final emailText = user.email.isNotEmpty ? ' (${user.email})' : '';

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(gzFile.path)],
        subject: 'Cadangan Database Runway Finance$emailText',
        text: 'File cadangan keuangan Runway Finance$emailText tanggal ${DateFormat('dd MMM yyyy HH:mm').format(DateTime.now())}.',
      ),
    );
  }

  /// Baca waktu pencadangan terakhir
  Future<DateTime?> getLastBackupTime() async {
    final val = await _settingsDao.getValue('last_backup_at');
    if (val == null || val.isEmpty) return null;
    return DateTime.tryParse(val);
  }

  /// Watch waktu pencadangan terakhir secara reaktif
  Stream<DateTime?> watchLastBackupTime() {
    return _settingsDao.watchValue('last_backup_at').map((val) {
      if (val == null || val.isEmpty) return null;
      return DateTime.tryParse(val);
    });
  }

  /// Daftar file cadangan lokal
  Future<List<File>> getLocalBackups() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final backupFolder = Directory('${appDocDir.path}/backups');
    if (!await backupFolder.exists()) return [];

    final list = backupFolder.listSync().whereType<File>().where((f) => f.path.endsWith('.db.gz')).toList();
    list.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return list;
  }
}
