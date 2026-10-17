import 'package:intl/intl.dart';

/// Formatter uang khusus Rupiah integer.
/// Aturan: JANGAN pakai float/double untuk uang. Semua nominal adalah int Rupiah.
class MoneyFormatter {
  MoneyFormatter._();

  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final NumberFormat _numberOnlyFormatter = NumberFormat.decimalPattern('id_ID');

  /// Format nominal integer ke string "Rp 1.500.000"
  static String format(int amount) {
    return _formatter.format(amount);
  }

  /// Format angka saja tanpa simbol "1.500.000"
  static String formatWithoutSymbol(int amount) {
    return _numberOnlyFormatter.format(amount);
  }

  /// Parse string input kembali ke integer Rupiah
  /// Mengabaikan karakter non-digit (seperti "Rp", titik, koma, spasi).
  static int parse(String text) {
    final clean = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.isEmpty) return 0;
    return int.tryParse(clean) ?? 0;
  }
}
