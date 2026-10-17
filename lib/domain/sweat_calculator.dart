/// Logika murni Kalkulator Keringat (Sweat Calculator).
/// Menerjemahkan pengeluaran kategori Wants menjadi satuan hari runway yang dikorbankan.
class SweatCalculator {
  SweatCalculator._();

  /// Menghitung berapa hari daya tahan hidup yang dikorbankan untuk nominal ini.
  /// Mengembalikan nilai dibulatkan ke 1 angka di belakang koma.
  /// Mengembalikan `null` jika avgDailySpend tidak valid.
  static double? calculateCostInDays({
    required int amount,
    required int? avgDailySpend,
  }) {
    if (avgDailySpend == null || avgDailySpend <= 0 || amount <= 0) {
      return null;
    }
    final rawCost = amount / avgDailySpend;
    return double.parse(rawCost.toStringAsFixed(1));
  }

  /// Menentukan apakah dialog konfirmasi pengorbanan harus dimunculkan.
  /// Default: hanya jika costInDays >= 0.1 hari.
  static bool shouldShowPrompt(
    double? costInDays, {
    double minDaysThreshold = 0.1,
  }) {
    if (costInDays == null) return false;
    return costInDays >= minDaysThreshold;
  }
}
