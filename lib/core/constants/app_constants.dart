/// Konstanta global untuk Runway Finance.
/// Jangan hardcode nilai-nilai ini di tempat lain.
class AppConstants {
  AppConstants._();

  static const String appName = 'Runway Finance';
  static const String appVersion = '1.0.0';

  /// Zona waktu acuan aplikasi (WITA, UTC+8)
  static const String defaultTimeZone = 'Asia/Makassar';
  static const int timeZoneOffsetHours = 8;

  /// Target ideal runway
  static const int safeRunwayDaysThreshold = 30;
  static const int warningRunwayDaysThreshold = 15;

  /// Default jendela perhitungan pengeluaran harian
  static const int defaultAvgDailySpendDays = 30;
  static const int minDaysForAvgCalculation = 7;

  /// Minimum target sentuh (dp) sesuai pedoman aksesibilitas dan brutalism
  static const double minTouchTargetSize = 48.0;

  /// Nama box / file lokal
  static const String databaseName = 'runway_finance.sqlite';
}
