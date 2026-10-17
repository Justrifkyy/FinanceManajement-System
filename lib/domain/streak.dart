/// Logika murni Puasa Jajan (Wants Spending Fast Streak).
/// Menghitung berapa hari berturut-turut pengguna mampu menahan diri dari pengeluaran Wants.
class StreakCalculator {
  StreakCalculator._();

  /// Menghitung streak saat ini berdasarkan himpunan tanggal di mana terdapat transaksi Wants.
  ///
  /// [wantsExpenseDates]: Kumpulan string tanggal 'YYYY-MM-DD' yang memiliki pengeluaran Wants.
  /// [todayLocalDate]: Tanggal hari ini 'YYYY-MM-DD' (WITA).
  /// [appStartedLocalDate]: Tanggal pertama kali aplikasi mulai digunakan 'YYYY-MM-DD' (WITA).
  static int calculateCurrentStreak({
    required Set<String> wantsExpenseDates,
    required String todayLocalDate,
    required String appStartedLocalDate,
  }) {
    final today = DateTime.tryParse(todayLocalDate);
    final appStart = DateTime.tryParse(appStartedLocalDate);
    if (today == null || appStart == null || today.isBefore(appStart)) {
      return 0;
    }

    // Jika hari ini sudah ada transaksi Wants, streak langsung reset ke 0
    if (wantsExpenseDates.contains(todayLocalDate)) {
      return 0;
    }

    int streak = 0;
    DateTime cursor = today;

    while (!cursor.isBefore(appStart)) {
      final dateStr = _formatDate(cursor);
      if (wantsExpenseDates.contains(dateStr)) {
        break; // Ditemukan pengeluaran Wants, rantai streak terputus
      }
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// Menghitung status apakah streak saat ini memecahkan rekor sebelumnya.
  static bool isNewRecord(int currentStreak, int previousLongestStreak) {
    return currentStreak > previousLongestStreak && currentStreak > 0;
  }

  static String _formatDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
