/// Kumpulan teks UI antarmuka (Bahasa Indonesia).
/// Nada bicara: santai, jujur, sedikit menampar tapi tidak menghakimi ("kamu").
class AppStrings {
  AppStrings._();

  // Tab & Navigasi
  static const String tabHome = 'BERANDA';
  static const String tabBudget = 'ALOKASI';
  static const String tabFuture = 'TARGET';

  // Health Bar Status
  static const String statusSafe = 'AMAN';
  static const String statusWarning = 'WASPADA';
  static const String statusDanger = 'BAHAYA';
  static const String statusNoData = 'BELUM ADA DATA';

  static const String statusSafeDesc = 'Napasmu masih panjang. Tetap disiplin!';
  static const String statusWarningDesc = 'Mulai berhemat! Utamakan kebutuhan primer.';
  static const String statusDangerDesc = 'Zona kritis! Setop semua jajan non-esensial sekarang!';
  static const String statusNoDataDesc = 'Catat transaksi selama beberapa hari untuk melihat runway.';

  // Unit
  static const String days = 'HARI';
  static const String daysSuffix = 'hari';
  static const String rupiahPrefix = 'Rp ';

  // Survival / Beranda
  static const String runwayQuestion = 'Berapa hari kamu bisa bertahan hidup?';
  static const String pendingIncome = 'Uang di Jalan';
  static const String fastJajanStreak = 'Puasa Jajan';
  static const String fastJajanDays = 'hari tanpa jajan';
  static const String recordSuffix = 'Rekor:';

  // Kolam Alokasi
  static const String unassignedFunds = 'Uang Belum Ditugaskan';
  static const String unassignedTargetZero = 'Beri tugas untuk setiap rupiah (target Rp 0)';
  static const String needsEnvelope = 'Kebutuhan (Needs)';
  static const String wantsEnvelope = 'Keinginan (Wants)';
  static const String bufferEnvelope = 'Bantalan Bulan Depan';
  static const String subscriptionRadar = 'Radar Langganan';

  // Transaksi
  static const String newTransaction = 'Catat Transaksi';
  static const String expense = 'Pengeluaran';
  static const String income = 'Pemasukan';
  static const String transfer = 'Pindah Amplop';
  static const String save = 'SIMPAN';
  static const String cancel = 'BATAL';
  static const String delete = 'HAPUS';

  // Kalkulator Keringat
  static const String sweatCalculatorTitle = 'Kalkulator Keringat';
  static const String sweatSacrifice = 'Pengeluaran ini setara dengan mengorbankan';
  static const String sweatDecisionQuestion = 'Yakin masih mau lanjut jajan?';
  static const String sweatResist = 'SAYA TAHAN DIRI';
  static const String sweatProceed = 'TETAP BELI';

  // Backup & Pemulihan
  static const String backup = 'Backup Data';
  static const String restore = 'Pulihkan Data';
  static const String backupGoogleDrive = 'Google Drive';
  static const String lastBackup = 'Backup terakhir:';
  static const String neverBackup = 'Belum pernah dibackup';
  static const String restoreWarning =
      'Memulihkan data akan menimpa seluruh data lokal saat ini. Lanjutkan?';

  // Errors & Validations
  static const String errorGeneric = 'Terjadi kesalahan. Coba lagi.';
  static const String errorEmptyAmount = 'Nominal harus lebih dari 0';
  static const String errorEmptyName = 'Nama tidak boleh kosong';
}
