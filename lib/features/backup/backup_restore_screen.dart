import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/providers/backup_provider.dart';
import 'package:runway_finance/services/backup/auth_service.dart';
import 'package:runway_finance/services/backup/drive_client.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_button.dart';
import 'package:runway_finance/shared/widgets/brutal/page_headers.dart';
import 'package:runway_finance/shared/widgets/brutal/stamp.dart';

class BackupRestoreScreen extends ConsumerStatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  ConsumerState<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends ConsumerState<BackupRestoreScreen> {
  bool _isLoading = false;
  String? _statusMessage;
  List<File> _localBackups = [];
  List<DriveBackupItem> _driveBackups = [];

  @override
  void initState() {
    super.initState();
    _loadBackups();
  }

  Future<void> _loadBackups() async {
    final backupService = ref.read(backupServiceProvider);
    final user = await ref.read(authServiceProvider).getCurrentUser();

    final locals = await backupService.getLocalBackups();
    List<DriveBackupItem> drives = [];
    if (user.authType == 'google') {
      try {
        drives = await backupService.driveClient.listBackups();
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        _localBackups = locals;
        _driveBackups = drives;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Menghubungkan ke Google...';
    });

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.signInWithGoogle();
      if (user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✓ Berhasil masuk sebagai ${user.email}!')),
        );
        await _loadBackups();
      }
    } catch (e) {
      if (mounted) {
        _showGoogleErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = null;
        });
      }
    }
  }

  void _showGoogleErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BrutalTokens.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
        title: const Text(
          'INFO LOGIN GOOGLE',
          style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Login Google membutuhkan pendaftaran sertifikat SHA-1 di Google Cloud Console. Kamu juga bisa memasukkan email secara langsung untuk menautkan akun cadangan.',
              style: TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Text(
              'Detail teknis: $error',
              style: const TextStyle(fontFamily: BrutalTokens.fontNumbers, fontSize: 10, color: BrutalTokens.muted),
            ),
          ],
        ),
        actions: [
          BrutalButton(
            text: 'TAUTKAN EMAIL MANUAL',
            variant: BrutalButtonVariant.primary,
            onPressed: () {
              Navigator.of(ctx).pop();
              _showManualEmailDialog();
            },
          ),
          BrutalButton(
            text: 'TUTUP',
            variant: BrutalButtonVariant.neutral,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  void _showManualEmailDialog() {
    final emailCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BrutalTokens.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
        title: const Text(
          'TAUTKAN EMAIL',
          style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap / Panggilan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Alamat Email (misal: user@gmail.com)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          BrutalButton(
            text: 'BATAL',
            variant: BrutalButtonVariant.neutral,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          BrutalButton(
            text: 'SIMPAN',
            variant: BrutalButtonVariant.primary,
            onPressed: () async {
              final email = emailCtrl.text.trim();
              if (email.isNotEmpty && email.contains('@')) {
                final authService = ref.read(authServiceProvider);
                await authService.signInWithEmail(
                  email: email,
                  name: nameCtrl.text.trim(),
                );
                if (ctx.mounted) Navigator.of(ctx).pop();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('✓ Akun berhasil ditautkan ke $email!')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleBackupNow() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Menyimpan & mengompres database...';
    });

    try {
      final backupService = ref.read(backupServiceProvider);
      final result = await backupService.backupNow();

      if (result.isSuccess) {
        await _loadBackups();
        if (mounted) {
          final sizeKb = (result.fileSizeBytes / 1024).toStringAsFixed(1);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.driveFileId != null
                    ? '✓ Berhasil dicadangkan ke Google Drive & Penyimpanan HP ($sizeKb KB)!'
                    : '✓ Berhasil dicadangkan ke Penyimpanan HP ($sizeKb KB)!',
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mencadangkan: ${result.errorMessage}')),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = null;
        });
      }
    }
  }

  Future<void> _handleShareToEmail() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Mempersiapkan pengiriman cadangan...';
    });

    try {
      final backupService = ref.read(backupServiceProvider);
      await backupService.shareBackupFile();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membagikan cadangan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = null;
        });
      }
    }
  }

  Future<void> _handleRestoreFile(File file) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BrutalTokens.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
        title: const Text(
          'PULIHKAN DATA?',
          style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
        ),
        content: const Text(
          'Seluruh data transaksi dan amplop saat ini akan digantikan dengan data dari file cadangan ini. Salinan pengaman akan dibuat secara otomatis.',
          style: TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 13),
        ),
        actions: [
          BrutalButton(
            text: 'BATAL',
            variant: BrutalButtonVariant.neutral,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          BrutalButton(
            text: 'PULIHKAN SEKARANG',
            variant: BrutalButtonVariant.danger,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'Memulihkan database...';
    });

    try {
      final restoreService = ref.read(restoreServiceProvider);
      final result = await restoreService.restoreFromFile(file);

      if (mounted) {
        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✓ Data berhasil dipulihkan!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memulihkan: ${result.message}')),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final lastBackupAsync = ref.watch(lastBackupTimeProvider);

    return Scaffold(
      backgroundColor: BrutalTokens.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
          children: [
            DetailHeader(
              eyebrow: 'PENYIMPANAN CLOUD & EMAIL',
              title: 'Backup & restore',
              onBack: () => context.pop(),
            ),

            // 1. Kartu Status Akun & Email
            userAsync.when(
              data: (user) {
                final isLoggedIn = user.isLoggedIn;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isLoggedIn ? BrutalTokens.paper : BrutalTokens.warn,
                    borderRadius: BrutalTokens.radiusZero,
                    border: Border.all(
                      color: BrutalTokens.ink,
                      width: BrutalTokens.borderHeavy,
                    ),
                    boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: isLoggedIn ? BrutalTokens.safe : BrutalTokens.paper,
                              border: Border.all(
                                color: BrutalTokens.ink,
                                width: BrutalTokens.borderBase,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: user.photoUrl != null
                                ? Image.network(user.photoUrl!, width: 52, height: 52, fit: BoxFit.cover)
                                : Text(
                                    isLoggedIn && user.name.isNotEmpty
                                        ? user.name.substring(0, 1).toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontNumbers,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isLoggedIn ? user.name : 'AKUN BELUM TERHUBUNG',
                                  style: const TextStyle(
                                    fontFamily: BrutalTokens.fontUi,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: BrutalTokens.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isLoggedIn ? user.email : 'Data saat ini hanya tersimpan di memori HP lokal.',
                                  style: const TextStyle(
                                    fontFamily: BrutalTokens.fontUi,
                                    fontSize: 12,
                                    color: BrutalTokens.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stamp(
                            text: isLoggedIn
                                ? (user.authType == 'google' ? '● GOOGLE DRIVE' : '● EMAIL TERTAUT')
                                : 'OFFLINE',
                            backgroundColor: isLoggedIn ? BrutalTokens.needs : BrutalTokens.paper,
                          ),
                          if (isLoggedIn)
                            GestureDetector(
                              onTap: () async {
                                final authService = ref.read(authServiceProvider);
                                await authService.signOut();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Akun berhasil diputuskan.')),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: BrutalTokens.ink, width: 1.5),
                                  ),
                                ),
                                child: const Text(
                                  'GANTI AKUN',
                                  style: TextStyle(
                                    fontFamily: BrutalTokens.fontUi,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: BrutalTokens.ink,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (!isLoggedIn) ...[
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: BrutalButton(
                                text: 'LOGIN GOOGLE',
                                variant: BrutalButtonVariant.primary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: BrutalTokens.spaceMd,
                                ),
                                onPressed: _handleGoogleSignIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: BrutalButton(
                                text: 'TAUT EMAIL',
                                variant: BrutalButtonVariant.neutral,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: BrutalTokens.spaceMd,
                                ),
                                onPressed: _showManualEmailDialog,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 18),

            // 2. Info Terakhir Dicadangkan
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BrutalTokens.paper,
                borderRadius: BrutalTokens.radiusZero,
                border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderBase),
                boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.history, size: 24, color: BrutalTokens.ink),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'STATUS PENCADANGAN',
                          style: TextStyle(
                            fontFamily: BrutalTokens.fontUi,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: BrutalTokens.muted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        lastBackupAsync.when(
                          data: (time) => Text(
                            time != null
                                ? 'Terakhir: ${DateFormat('dd MMM yyyy, HH:mm').format(time)} WITA'
                                : 'Belum pernah dicadangkan',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontUi,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: BrutalTokens.ink,
                            ),
                          ),
                          loading: () => const Text('Memeriksa...'),
                          error: (_, _) => const Text('Tidak ada riwayat'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 3. Tombol Aksi Utama Pencadangan
            if (_isLoading)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BrutalTokens.paper,
                  border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderBase),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: BrutalTokens.ink),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        _statusMessage ?? 'Sedang memproses...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              BrutalButton(
                text: '💾 CADANGKAN SEKARANG',
                variant: BrutalButtonVariant.safe,
                isFullWidth: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: BrutalTokens.spaceMd,
                ),
                onPressed: _handleBackupNow,
              ),
              const SizedBox(height: 10),
              BrutalButton(
                text: '✉️ KIRIM CADANGAN KE EMAIL',
                variant: BrutalButtonVariant.primary,
                isFullWidth: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: BrutalTokens.spaceMd,
                ),
                onPressed: _handleShareToEmail,
              ),
            ],
            const SizedBox(height: 24),

            // 4. Daftar File Cadangan Lokal & Pemulihan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DAFTAR FILE CADANGAN',
                  style: TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                    color: BrutalTokens.ink,
                  ),
                ),
                GestureDetector(
                  onTap: _loadBackups,
                  child: const Text(
                    'SEGARKAN',
                    style: TextStyle(
                      fontFamily: BrutalTokens.fontUi,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: BrutalTokens.ink,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (_localBackups.isEmpty && _driveBackups.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: BrutalTokens.paper,
                  border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Belum ada file cadangan yang tersimpan.\nTekan tombol CADANGKAN SEKARANG di atas untuk membuat cadangan pertamamu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              )
            else ...[
              // Tampilkan daftar cadangan lokal
              ..._localBackups.map((f) {
                final sizeKb = (f.lengthSync() / 1024).toStringAsFixed(1);
                final modified = f.lastModifiedSync();
                final name = f.path.split(Platform.pathSeparator).last;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: BrutalTokens.paper,
                    borderRadius: BrutalTokens.radiusZero,
                    border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                    boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        color: BrutalTokens.needs,
                        child: const Icon(Icons.folder_zip_outlined, color: BrutalTokens.ink, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: BrutalTokens.fontNumbers,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${DateFormat('dd MMM yyyy HH:mm').format(modified)} · $sizeKb KB (Lokal)',
                              style: const TextStyle(
                                fontFamily: BrutalTokens.fontUi,
                                fontSize: 10,
                                color: BrutalTokens.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      BrutalButton(
                        text: 'PULIHKAN',
                        variant: BrutalButtonVariant.neutral,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        onPressed: () => _handleRestoreFile(f),
                      ),
                    ],
                  ),
                );
              }),

              // Tampilkan cadangan Google Drive jika ada
              ..._driveBackups.map((d) {
                final sizeKb = d.sizeBytes != null ? (d.sizeBytes! / 1024).toStringAsFixed(1) : '?';
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: BrutalTokens.paper,
                    borderRadius: BrutalTokens.radiusZero,
                    border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                    boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        color: BrutalTokens.warn,
                        child: const Icon(Icons.cloud_done_outlined, color: BrutalTokens.ink, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: BrutalTokens.fontNumbers,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${d.modifiedTime != null ? DateFormat('dd MMM yyyy HH:mm').format(d.modifiedTime!) : '-'} · $sizeKb KB (Google Drive)',
                              style: const TextStyle(
                                fontFamily: BrutalTokens.fontUi,
                                fontSize: 10,
                                color: BrutalTokens.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
