import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
    super.close();
  }
}

class DriveBackupItem {
  final String id;
  final String name;
  final DateTime? modifiedTime;
  final int? sizeBytes;

  const DriveBackupItem({
    required this.id,
    required this.name,
    this.modifiedTime,
    this.sizeBytes,
  });
}

class DriveClient {
  final AuthService _authService;

  DriveClient(this._authService);

  Future<drive.DriveApi?> _getDriveApi() async {
    final headers = await _authService.getGoogleAuthHeaders();
    if (headers == null) return null;
    final client = GoogleAuthClient(headers);
    return drive.DriveApi(client);
  }

  /// Upload file cadangan ke Google Drive (appDataFolder tersembunyi)
  Future<String?> uploadBackup(File file, String fileName) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      throw Exception('Gagal menghubungi Google Drive: akun belum terhubung dengan Google.');
    }

    final fileToUpload = drive.File()
      ..name = fileName
      ..parents = ['appDataFolder']
      ..description = 'Cadangan Database Runway Finance'
      ..appProperties = {
        'app': 'runway_finance',
        'type': 'sqlite_backup',
        'created_at': DateTime.now().toUtc().toIso8601String(),
      };

    final media = drive.Media(file.openRead(), file.lengthSync());
    final result = await driveApi.files.create(
      fileToUpload,
      uploadMedia: media,
      $fields: 'id, name, createdTime',
    );

    return result.id;
  }

  /// Daftar file cadangan yang tersimpan di Google Drive pengguna
  Future<List<DriveBackupItem>> listBackups() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return [];

    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      $fields: 'files(id, name, modifiedTime, size)',
      orderBy: 'modifiedTime desc',
    );

    final files = fileList.files ?? [];
    return files.map((f) {
      return DriveBackupItem(
        id: f.id ?? '',
        name: f.name ?? 'runway_backup.db.gz',
        modifiedTime: f.modifiedTime,
        sizeBytes: int.tryParse(f.size ?? '0'),
      );
    }).toList();
  }

  /// Unduh file cadangan dari Google Drive
  Future<void> downloadBackup(String fileId, String savePath) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      throw Exception('Akun Google belum terhubung.');
    }

    final media = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final targetFile = File(savePath);
    final sink = targetFile.openWrite();
    await media.stream.pipe(sink);
    await sink.close();
  }

  /// Hapus file lama dari Google Drive
  Future<void> deleteBackup(String fileId) async {
    final driveApi = await _getDriveApi();
    if (driveApi != null) {
      await driveApi.files.delete(fileId);
    }
  }
}
