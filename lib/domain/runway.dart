/// Status kesehatan keuangan (Health Bar)
enum HealthStatus {
  safe,
  warning,
  danger,
  noData,
}

/// Logika murni perhitungan Runway dan Health Bar.
/// Dilarang impor Flutter / Drift / Riverpod di sini.
class RunwayCalculator {
  RunwayCalculator._();

  /// Menghitung rata-rata pengeluaran harian (avg_daily_spend).
  ///
  /// [totalSpending30Days]: total pengeluaran kategori Needs + Wants dalam periode.
  /// [daysSinceFirstTransaction]: jumlah hari sejak transaksi pertama pengguna.
  /// [windowDays]: default 30 hari.
  /// [minDays]: batas minimum hari untuk memulai perhitungan (default 7 hari).
  static int? calculateAvgDailySpend({
    required int totalSpending30Days,
    required int daysSinceFirstTransaction,
    int windowDays = 30,
    int minDays = 7,
  }) {
    if (daysSinceFirstTransaction < minDays) {
      return null; // Belum cukup data (status noData)
    }

    final effectiveDays = daysSinceFirstTransaction < windowDays
        ? daysSinceFirstTransaction
        : windowDays;

    if (effectiveDays <= 0) return null;
    return (totalSpending30Days / effectiveDays).round();
  }

  /// Menghitung jumlah hari runway (runway_days).
  ///
  /// [liquidCash]: Saldo Unassigned + Needs + Wants (dalam Rupiah).
  /// [avgDailySpend]: Rata-rata pengeluaran harian (dalam Rupiah).
  /// Mengembalikan `null` jika belum ada pengeluaran (tidak dibagi nol).
  static int? calculateRunwayDays({
    required int liquidCash,
    required int? avgDailySpend,
  }) {
    if (avgDailySpend == null || avgDailySpend <= 0) {
      return null;
    }
    if (liquidCash <= 0) {
      return 0;
    }
    return (liquidCash / avgDailySpend).floor();
  }

  /// Menentukan status Health Bar berdasarkan jumlah hari runway.
  static HealthStatus determineHealthStatus(
    int? runwayDays, {
    int safeThreshold = 30,
    int warningThreshold = 15,
  }) {
    if (runwayDays == null) {
      return HealthStatus.noData;
    }
    if (runwayDays > safeThreshold) {
      return HealthStatus.safe;
    }
    if (runwayDays >= warningThreshold) {
      return HealthStatus.warning;
    }
    return HealthStatus.danger;
  }
}
