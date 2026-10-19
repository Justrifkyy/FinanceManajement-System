import 'package:intl/intl.dart';

/// Helper tanggal sesuai konvensi waktu Asia/Makassar (WITA, UTC+8).
/// Pergantian hari bisnis pada 00:00 WITA.
/// Bulan baru pada tanggal 1 pukul 00:00 WITA.
class DateHelper {
  DateHelper._();

  static const Duration timeZoneOffset = Duration(hours: 8);

  static final DateFormat _localDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _releaseMonthFormat = DateFormat('yyyy-MM');
  static final DateFormat _displayDateFormat = DateFormat('d MMMM yyyy', 'id_ID');

  /// Mengonversi DateTime ke waktu lokal Asia/Makassar (UTC+8)
  static DateTime toMakassarTime(DateTime utcOrLocal) {
    return utcOrLocal.toUtc().add(timeZoneOffset);
  }

  /// Mendapatkan string 'YYYY-MM-DD' menurut waktu Asia/Makassar
  static String toLocalDateString(DateTime dateTime) {
    return _localDateFormat.format(toMakassarTime(dateTime));
  }

  /// Mendapatkan string 'YYYY-MM' untuk release_month
  static String toReleaseMonthString(DateTime dateTime) {
    return _releaseMonthFormat.format(toMakassarTime(dateTime));
  }

  /// Format tanggal untuk tampilan UI santai: "17 Oktober 2026"
  static String formatDisplayDate(DateTime dateTime) {
    try {
      return _displayDateFormat.format(toMakassarTime(dateTime));
    } catch (_) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  /// Mendapatkan tanggal hari ini dalam format 'YYYY-MM-DD' WITA
  static String todayLocalDateString() {
    return toLocalDateString(DateTime.now());
  }

  /// Mendapatkan tanggal kemarin dalam format 'YYYY-MM-DD' WITA
  static String yesterdayLocalDateString() {
    return toLocalDateString(DateTime.now().subtract(const Duration(days: 1)));
  }

  /// Awal hari (00:00:00) waktu WITA untuk tanggal tertentu
  static DateTime startOfDay(DateTime dt) {
    final makassar = toMakassarTime(dt);
    final startLocal = DateTime.utc(makassar.year, makassar.month, makassar.day);
    return startLocal.subtract(timeZoneOffset);
  }

  /// Awal bulan (tanggal 1 00:00:00) waktu WITA untuk tanggal tertentu
  static DateTime startOfMonth(DateTime dt) {
    final makassar = toMakassarTime(dt);
    final startLocal = DateTime.utc(makassar.year, makassar.month, 1);
    return startLocal.subtract(timeZoneOffset);
  }
}
