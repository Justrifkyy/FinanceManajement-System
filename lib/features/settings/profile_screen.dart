import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/providers/backup_provider.dart';
import 'package:runway_finance/providers/database_provider.dart';
import 'package:runway_finance/providers/notification_provider.dart';
import 'package:runway_finance/providers/repository_providers.dart';
import 'package:runway_finance/providers/runway_provider.dart';
import 'package:runway_finance/services/backup/auth_service.dart';
import 'package:runway_finance/services/notification_service.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_button.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_toggle.dart';
import 'package:runway_finance/shared/widgets/brutal/page_headers.dart';
import 'package:runway_finance/shared/widgets/brutal/stamp.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_toast.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _dailyReminder = true;
  bool _frugalReminder = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreferences();
  }

  Future<void> _loadNotificationPreferences() async {
    final settingsDao = ref.read(settingsDaoProvider);
    final daily = await settingsDao.getBool('daily_reminder_enabled', defaultValue: true);
    final frugal = await settingsDao.getBool('frugal_motivation_enabled', defaultValue: true);
    if (mounted) {
      setState(() {
        _dailyReminder = daily;
        _frugalReminder = frugal;
      });
    }
  }

  void _showQuotesDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BrutalTokens.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
        title: const Text(
          'KUTIPAN MOTIVASI BERHEMAT',
          style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: NotificationService.frugalQuotes.length,
            separatorBuilder: (_, _) => const Divider(color: BrutalTokens.ink),
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💡 ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        NotificationService.frugalQuotes[index],
                        style: const TextStyle(
                          fontFamily: BrutalTokens.fontUi,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: BrutalTokens.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          BrutalButton(
            text: 'TUTUP',
            variant: BrutalButtonVariant.neutral,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final runwayState = ref.watch(runwayProvider).asData?.value;
    final runwayDays = runwayState?.runwayDays ?? 0;
    final userAsync = ref.watch(currentUserProvider);
    final lastBackupAsync = ref.watch(lastBackupTimeProvider);

    return Scaffold(
      backgroundColor: BrutalTokens.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
          children: [
            DetailHeader(
              eyebrow: 'AKUN & PENGATURAN',
              title: 'Profil',
              onBack: () => context.pop(),
            ),

            // Profile Card (Reaktif dengan Akun Pengguna)
            userAsync.when(
              data: (user) {
                final isLoggedIn = user.isLoggedIn;
                final initials = isLoggedIn && user.name.isNotEmpty
                    ? user.name.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
                    : '?';

                return GestureDetector(
                  onTap: () => context.push('/backup'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isLoggedIn ? BrutalTokens.needs : BrutalTokens.warn,
                      borderRadius: BrutalTokens.radiusZero,
                      border: Border.all(
                        color: BrutalTokens.ink,
                        width: BrutalTokens.borderHeavy,
                      ),
                      boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowLg),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: BrutalTokens.paper,
                            border: Border.all(
                              color: BrutalTokens.ink,
                              width: BrutalTokens.borderBase,
                            ),
                            boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                          ),
                          alignment: Alignment.center,
                          child: user.photoUrl != null
                              ? Image.network(user.photoUrl!, width: 64, height: 64, fit: BoxFit.cover)
                              : Text(
                                  initials,
                                  style: const TextStyle(
                                    fontFamily: BrutalTokens.fontNumbers,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: BrutalTokens.ink,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stamp(
                                text: isLoggedIn
                                    ? (user.authType == 'google' ? '● GOOGLE' : '● EMAIL TERTAUT')
                                    : 'BELUM TERHUBUNG',
                                backgroundColor: BrutalTokens.paper,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isLoggedIn ? user.name : 'Tamu (Offline)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                              Text(
                                isLoggedIn ? user.email : 'Ketuk untuk hubungkan Google / Email',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 11,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: BrutalTokens.ink,
                                width: BrutalTokens.borderThin,
                              ),
                            ),
                          ),
                          child: Text(
                            isLoggedIn ? 'KELOLA' : 'MASUK',
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontUi,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: BrutalTokens.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),

            // Profile Stats (3 Columns)
            Container(
              decoration: BoxDecoration(
                color: BrutalTokens.paper,
                borderRadius: BrutalTokens.radiusZero,
                border: Border.all(
                  color: BrutalTokens.ink,
                  width: BrutalTokens.borderBase,
                ),
                boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
              ),
              child: Row(
                children: [
                  _buildStatColumn('$runwayDays', 'HARI RUNWAY'),
                  Container(width: BrutalTokens.borderThin, height: 50, color: BrutalTokens.ink),
                  _buildStatColumn('12', 'REKOR PUASA'),
                  Container(width: BrutalTokens.borderThin, height: 50, color: BrutalTokens.ink),
                  _buildStatColumn('5', 'AMPLOP'),
                ],
              ),
            ),

            const SectionTitle(title: 'Preferensi'),

            // Settings List
            Container(
              decoration: BoxDecoration(
                color: BrutalTokens.paper,
                borderRadius: BrutalTokens.radiusZero,
                border: Border.all(
                  color: BrutalTokens.ink,
                  width: BrutalTokens.borderBase,
                ),
              ),
              child: Column(
                children: [
                  // Row 1: Pengingat Harian (Toggle)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: BrutalTokens.needs,
                            border: Border.all(
                              color: BrutalTokens.ink,
                              width: BrutalTokens.borderThin,
                            ),
                          ),
                          child: const Icon(Icons.access_time, color: BrutalTokens.ink, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pengingat harian',
                                style: TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                              Text(
                                'Catat pengeluaran pukul 20.00',
                                style: TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 11,
                                  color: BrutalTokens.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        BrutalToggle(
                          value: _dailyReminder,
                          onChanged: (val) async {
                            setState(() => _dailyReminder = val);
                            final db = ref.read(databaseProvider);
                            await db.settingsDao.setBool('daily_reminder_enabled', val);
                            final notif = ref.read(notificationServiceProvider);
                            if (val) {
                              await notif.requestPermission();
                              await notif.scheduleDailyReminder(
                                id: NotificationService.idDailyLog,
                                title: '📝 Evaluasi Keuangan Hari Ini',
                                body: 'Sudah catat pengeluaran hari ini? 1 menit mencatat, amankan harimu ke depan.',
                                hour: 20,
                                minute: 0,
                              );
                            } else {
                              await notif.cancel(NotificationService.idDailyLog);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: BrutalTokens.borderThin, color: BrutalTokens.ink),

                  // Row 2: Motivasi Berhemat Acak (Toggle)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: BrutalTokens.warn,
                            border: Border.all(
                              color: BrutalTokens.ink,
                              width: BrutalTokens.borderThin,
                            ),
                          ),
                          child: const Icon(Icons.lightbulb_outline, color: BrutalTokens.ink, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Motivasi berhemat acak',
                                style: TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                              Text(
                                'Pengingat acak tahan godaan jajan (12.30)',
                                style: TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 11,
                                  color: BrutalTokens.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        BrutalToggle(
                          value: _frugalReminder,
                          onChanged: (val) async {
                            setState(() => _frugalReminder = val);
                            final db = ref.read(databaseProvider);
                            await db.settingsDao.setBool('frugal_motivation_enabled', val);
                            final notif = ref.read(notificationServiceProvider);
                            if (val) {
                              await notif.requestPermission();
                              await notif.scheduleDailyReminder(
                                id: NotificationService.idFrugalMotivation,
                                title: '💡 Ingat Yaa Berhemat!',
                                body: NotificationService.getRandomQuote(),
                                hour: 12,
                                minute: 30,
                              );
                            } else {
                              await notif.cancel(NotificationService.idFrugalMotivation);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: BrutalTokens.borderThin, color: BrutalTokens.ink),

                  // Row 3: Uji Notifikasi Berhemat (Kirim Langsung Sekarang)
                  _buildSettingsRow(
                    icon: Icons.notifications_active_outlined,
                    iconBg: BrutalTokens.safe,
                    title: 'Uji notifikasi berhemat',
                    subtitle: 'Kirim notifikasi motivasi acak ke status bar HP sekarang',
                    onTap: () async {
                      final notif = ref.read(notificationServiceProvider);
                      await notif.requestPermission();
                      await notif.showRandomFrugalMotivation();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✓ Notifikasi motivasi berhemat terkirim ke status bar HP kamu!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(height: 1, thickness: BrutalTokens.borderThin, color: BrutalTokens.ink),

                  // Row 4: Daftar Kutipan Berhemat (Intip dialog)
                  _buildSettingsRow(
                    icon: Icons.format_quote_outlined,
                    iconBg: BrutalTokens.needs,
                    title: 'Koleksi kutipan berhemat',
                    subtitle: 'Intip 14 pesan motivasi berhemat Runway Finance',
                    onTap: _showQuotesDialog,
                  ),
                  const Divider(height: 1, thickness: BrutalTokens.borderThin, color: BrutalTokens.ink),

                  // Row 5: Aturan runway
                  _buildSettingsRow(
                    icon: Icons.track_changes,
                    iconBg: BrutalTokens.needs,
                    title: 'Aturan runway',
                    subtitle: 'Semua pengeluaran · Target 30 hari',
                    onTap: () {},
                  ),
                  const Divider(height: 1, thickness: BrutalTokens.borderThin, color: BrutalTokens.ink),

                  // Row 3: Backup & pemulihan
                  _buildSettingsRow(
                    icon: Icons.cloud_outlined,
                    iconBg: lastBackupAsync.value != null ? BrutalTokens.safe : BrutalTokens.warn,
                    title: 'Backup & pemulihan',
                    subtitle: lastBackupAsync.when(
                      data: (dt) => dt != null
                          ? 'Terakhir ${DateFormat('dd MMM yyyy, HH:mm').format(dt)}'
                          : 'Belum pernah dicadangkan',
                      loading: () => 'Memeriksa status cadangan...',
                      error: (_, _) => 'Ketuk untuk cadangkan',
                    ),
                    onTap: () => context.push('/backup'),
                  ),
                  // Row 4: Riwayat Transaksi Lengkap
                  _buildSettingsRow(
                    icon: Icons.history,
                    iconBg: BrutalTokens.warn,
                    title: 'Riwayat Transaksi Lengkap',
                    subtitle: 'Buku besar histori seluruh pemasukan & pengeluaran',
                    onTap: () => context.push('/history'),
                  ),
                  const Divider(height: 1, thickness: BrutalTokens.borderThin, color: BrutalTokens.ink),

                  // Row 5: Ekspor data
                  _buildSettingsRow(
                    icon: Icons.send_outlined,
                    iconBg: BrutalTokens.needs,
                    title: 'Ekspor ke Email / Gmail',
                    subtitle: 'Kirim berkas cadangan database via email',
                    onTap: () async {
                      try {
                        BrutalToast.showInfo(
                          context,
                          title: 'MENYIAPKAN BERKAS',
                          message: 'Menyiapkan database terenkripsi untuk dibagikan...',
                        );
                        await ref.read(backupServiceProvider).shareBackupFile();
                      } catch (e) {
                        if (context.mounted) {
                          BrutalToast.showError(
                            context,
                            title: 'GAGAL MENGEKSPOR',
                            message: e.toString(),
                            pushToSystem: true,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section: Aturan Runway & Panduan Penggunaan
            const SectionTitle(title: 'Aturan runway & panduan'),

            // Card 1: Aturan Utama Runway
            _buildRunwayRulesCard(),
            const SizedBox(height: 14),

            // Card 2: Panduan Penggunaan 5 Langkah
            _buildRunwayUsageGuideCard(),
            const SizedBox(height: 28),

            // Version Block
            const Center(
              child: Column(
                children: [
                  Text(
                    'RUNWAY FINANCE',
                    style: TextStyle(
                      fontFamily: BrutalTokens.fontUi,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: BrutalTokens.ink,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'VERSI 1.0.0 · DATA TERSIMPAN LOKAL',
                    style: TextStyle(
                      fontFamily: BrutalTokens.fontUi,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: BrutalTokens.muted,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: BrutalTokens.fontNumbers,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: BrutalTokens.ink,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontFamily: BrutalTokens.fontUi,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: BrutalTokens.ink,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                border: Border.all(
                  color: BrutalTokens.ink,
                  width: BrutalTokens.borderThin,
                ),
              ),
              child: Icon(icon, color: BrutalTokens.ink, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: BrutalTokens.fontUi,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: BrutalTokens.ink,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: BrutalTokens.fontUi,
                      fontSize: 11,
                      color: BrutalTokens.muted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, size: 18, color: BrutalTokens.ink),
          ],
        ),
      ),
    );
  }

  Widget _buildRunwayRulesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrutalTokens.paper,
        border: Border.all(
          color: BrutalTokens.ink,
          width: BrutalTokens.borderBase,
        ),
        boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Stamp(text: 'FILOSOFI INTI', backgroundColor: BrutalTokens.warn),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: BrutalTokens.ink,
                child: const Text(
                  'STANDAR SURVIVAL',
                  style: TextStyle(
                    fontFamily: BrutalTokens.fontNumbers,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: BrutalTokens.paper,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'ATURAN UTAMA RUNWAY FINANCE',
            style: TextStyle(
              fontFamily: BrutalTokens.fontUi,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: BrutalTokens.ink,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Aplikasi ini tidak dirancang untuk sekadar mencatat angka, melainkan mengukur seberapa lama kamu bisa bertahan hidup jika hari ini semua pemasukanmu berhenti total.',
            style: TextStyle(
              fontFamily: BrutalTokens.fontUi,
              fontSize: 12,
              color: BrutalTokens.ink,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),

          _buildRuleItem(
            icon: '🎯',
            title: 'Target Runway Selalu > 30 Hari',
            desc: 'Rumus: Kas Likuid ÷ Rata-rata Pengeluaran Harian. Kamu harus memiliki daya tahan minimal 30 hari ke depan.',
          ),
          _buildRuleItem(
            icon: '🚦',
            title: '3 Zona Warna Runway',
            desc: '🟢 Hijau (>30 hari): Aman, tabung target impian.\n🟡 Kuning (15-30 hari): Waspada, batasi Keinginan.\n🔴 Merah (<15 hari): Bahaya Kritis, hanya belanja Kebutuhan!',
          ),
          _buildRuleItem(
            icon: '🛡️',
            title: 'Bantalan Bulan Depan (Buffer)',
            desc: 'Gaji/penghasilan bulan ini disimpan untuk pengeluaran bulan depan. Mencegah siklus gali lubang tutup lubang!',
          ),
          _buildRuleItem(
            icon: '💼',
            title: 'Buku Besar Tanpa Saldo Buatan',
            desc: 'Saldo diturunkan murni dari histori transaksi (Zero-Based), bukan angka yang diinput manual tanpa jejak.',
          ),
          _buildRuleItem(
            icon: '🔥',
            title: 'Puasa Jajan & Disiplin Finansial',
            desc: 'Menahan godaan jajan impulsif dan mengonversi rupiah yang batal keluar menjadi penambah hari hidup di Runway.',
          ),
        ],
      ),
    );
  }

  Widget _buildRunwayUsageGuideCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrutalTokens.paper,
        border: Border.all(
          color: BrutalTokens.ink,
          width: BrutalTokens.borderBase,
        ),
        boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Stamp(text: 'PANDUAN LENGKAP', backgroundColor: BrutalTokens.safe),
              const Text(
                '5 LANGKAH TAKTIS',
                style: TextStyle(
                  fontFamily: BrutalTokens.fontNumbers,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: BrutalTokens.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'CARA PENGGUNAAN RUNWAY FINANCE',
            style: TextStyle(
              fontFamily: BrutalTokens.fontUi,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: BrutalTokens.ink,
            ),
          ),
          const SizedBox(height: 12),

          _buildStepItem(
            step: '01',
            title: 'Catat Pemasukan',
            desc: 'Setiap menerima uang, buka "Catat Gerak Uang" > tab "MASUK". Arahkan ke "Belum Dialokasikan" atau simpan ke "Bantalan Bulan Depan". Beri deskripsi opsional (misal: "Gaji Kantor").',
          ),
          _buildStepItem(
            step: '02',
            title: 'Atur Alokasi Pos Amplop',
            desc: 'Buka menu "Atur Alokasi". Bagikan saldo kas ke pos Kebutuhan (Makan, Kost, Transport) dan Keinginan (Hiburan, Kopi). Setiap rupiah wajib memiliki tugas!',
          ),
          _buildStepItem(
            step: '03',
            title: 'Catat Pengeluaran Real-Time',
            desc: 'Setiap belanja, catat lewat "Catat Gerak Uang" > "KELUAR". Pilih amplop pos dan ketikkan deskripsi opsional (misal: "membeli permen kapas").',
          ),
          _buildStepItem(
            step: '04',
            title: 'Jalankan Puasa Jajan',
            desc: 'Saat tergoda jajan impulsif, tahan diri! Catat nominalnya di "Puasa Jajan" > "Catat Godaan Ditahan" untuk menaikkan rekor streak harianmu.',
          ),
          _buildStepItem(
            step: '05',
            title: 'Pantau Angka Runway di Beranda',
            desc: 'Lihat kartu besar di Beranda. Pastikan angka Runway selalu berada di zona hijau (> 30 hari). Semakin panjang harinya, semakin bebas hidupmu!',
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem({
    required String icon,
    required String title,
    required String desc,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: BrutalTokens.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 11,
                    color: BrutalTokens.muted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required String step,
    required String title,
    required String desc,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: BrutalTokens.warn,
              border: Border.all(
                color: BrutalTokens.ink,
                width: 1.5,
              ),
            ),
            child: Text(
              step,
              style: const TextStyle(
                fontFamily: BrutalTokens.fontNumbers,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: BrutalTokens.ink,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: BrutalTokens.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 11,
                    color: BrutalTokens.muted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

