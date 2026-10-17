import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:runway_finance/data/database/daos/settings_dao.dart';
import 'package:runway_finance/providers/repository_providers.dart';

class UserModel {
  final String email;
  final String name;
  final String? photoUrl;
  final String authType; // 'google', 'email', 'guest'
  final bool isLoggedIn;

  const UserModel({
    required this.email,
    required this.name,
    this.photoUrl,
    required this.authType,
    required this.isLoggedIn,
  });

  static const empty = UserModel(
    email: '',
    name: 'Tamu (Offline)',
    photoUrl: null,
    authType: 'guest',
    isLoggedIn: false,
  );
}

class AuthService {
  final SettingsDao _settingsDao;
  GoogleSignInAccount? _googleUser;
  bool _isInit = false;

  static const List<String> scopes = [
    'email',
    'https://www.googleapis.com/auth/drive.appdata',
  ];

  AuthService(this._settingsDao);

  Future<void> _ensureInitialized() async {
    if (_isInit) return;
    try {
      await GoogleSignIn.instance.initialize();
      _isInit = true;
    } catch (_) {}
  }

  /// Cek apakah pengguna saat ini sudah login
  Future<UserModel> getCurrentUser() async {
    final email = await _settingsDao.getValue('user_email');
    if (email == null || email.trim().isEmpty) {
      return UserModel.empty;
    }

    final name = await _settingsDao.getValue('user_name') ?? 'Pengguna';
    final photoUrl = await _settingsDao.getValue('user_photo_url');
    final authType = await _settingsDao.getValue('user_auth_type') ?? 'email';

    return UserModel(
      email: email,
      name: name,
      photoUrl: photoUrl,
      authType: authType,
      isLoggedIn: true,
    );
  }

  /// Watch status pengguna secara reaktif
  Stream<UserModel> watchCurrentUser() {
    return _settingsDao.watchValue('user_email').asyncMap((_) => getCurrentUser());
  }

  /// Login dengan Akun Google
  Future<UserModel?> signInWithGoogle() async {
    await _ensureInitialized();
    try {
      final account = await GoogleSignIn.instance.authenticate();
      _googleUser = account;

      // Minta izin scope Google Drive appdata jika belum
      try {
        await account.authorizationClient.authorizeScopes(scopes);
      } catch (_) {}

      final email = account.email;
      final name = account.displayName ?? 'Pengguna Google';
      final photoUrl = account.photoUrl;

      await _settingsDao.setValue('user_email', email);
      await _settingsDao.setValue('user_name', name);
      if (photoUrl != null) {
        await _settingsDao.setValue('user_photo_url', photoUrl);
      }
      await _settingsDao.setValue('user_auth_type', 'google');
      await _settingsDao.setValue('backup_google_email', email);

      return UserModel(
        email: email,
        name: name,
        photoUrl: photoUrl,
        authType: 'google',
        isLoggedIn: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Tautkan / Login dengan Email Manual
  Future<UserModel> signInWithEmail({
    required String email,
    required String name,
  }) async {
    final cleanEmail = email.trim();
    final cleanName = name.trim().isEmpty ? 'Pengguna' : name.trim();

    await _settingsDao.setValue('user_email', cleanEmail);
    await _settingsDao.setValue('user_name', cleanName);
    await _settingsDao.setValue('user_auth_type', 'email');
    await _settingsDao.setValue('backup_google_email', cleanEmail);

    return UserModel(
      email: cleanEmail,
      name: cleanName,
      photoUrl: null,
      authType: 'email',
      isLoggedIn: true,
    );
  }

  /// Dapatkan HTTP Auth Headers untuk Google APIs (Google Drive)
  Future<Map<String, String>?> getGoogleAuthHeaders() async {
    await _ensureInitialized();
    try {
      GoogleSignInAccount? account = _googleUser;
      if (account == null) {
        final lightweightAttempt = GoogleSignIn.instance.attemptLightweightAuthentication();
        if (lightweightAttempt != null) {
          account = await lightweightAttempt;
          _googleUser = account;
        }
      }

      if (account == null) return null;

      var headers = await account.authorizationClient.authorizationHeaders(scopes);
      if (headers == null) {
        await account.authorizationClient.authorizeScopes(scopes);
        headers = await account.authorizationClient.authorizationHeaders(scopes);
      }
      return headers;
    } catch (_) {
      return null;
    }
  }

  /// Logout / Putuskan Akun
  Future<void> signOut() async {
    await _ensureInitialized();
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    _googleUser = null;

    await _settingsDao.setValue('user_email', '');
    await _settingsDao.setValue('user_name', '');
    await _settingsDao.setValue('user_photo_url', '');
    await _settingsDao.setValue('user_auth_type', 'guest');
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final settingsDao = ref.watch(settingsDaoProvider);
  return AuthService(settingsDao);
});

final currentUserProvider = StreamProvider<UserModel>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.watchCurrentUser();
});
