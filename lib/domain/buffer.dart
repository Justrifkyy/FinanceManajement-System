/// Logika murni Bantalan Bulan Depan (Income Buffer).
/// Menyembunyikan sebagian pendapatan besar dan mencairkannya otomatis pada tanggal 1 bulan depan.
class BufferLogic {
  BufferLogic._();

  static const int defaultMinIncomeThreshold = 1000000; // Rp 1.000.000

  /// Menghitung apakah saran Bantalan Bulan Depan harus ditampilkan.
  static bool shouldOfferBuffer({
    required int incomeAmount,
    int minThreshold = defaultMinIncomeThreshold,
  }) {
    return incomeAmount >= minThreshold;
  }

  /// Menghitung saran nominal yang disisihkan ke Bantalan:
  /// default 1/3 dari nominal pemasukan ATAU sebesar rata-rata bulanan Needs (mana yang lebih kecil).
  static int calculateSuggestedAmount({
    required int incomeAmount,
    int? avgMonthlyNeeds,
  }) {
    final oneThird = (incomeAmount / 3).round();
    if (avgMonthlyNeeds != null && avgMonthlyNeeds > 0) {
      return oneThird < avgMonthlyNeeds ? oneThird : avgMonthlyNeeds;
    }
    return oneThird;
  }

  /// Mengecek apakah suatu entri Bantalan sudah jatuh tempo untuk dicairkan.
  /// Format releaseMonth: 'YYYY-MM'.
  static bool isDueForRelease({
    required String releaseMonth,
    required String currentMonth,
  }) {
    return releaseMonth.compareTo(currentMonth) <= 0;
  }

  /// Menghasilkan format 'YYYY-MM' untuk bulan berikutnya setelah tanggal tertentu.
  static String getNextMonthString(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month + 1;
    if (month > 12) {
      year += 1;
      month = 1;
    }
    return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';
  }
}
