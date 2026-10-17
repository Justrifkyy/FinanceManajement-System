enum PacingStatus {
  achieved,
  onTrack,
  overdue,
  noDeadline,
}

/// Logika murni ritme tabungan (Savings Pacing).
class SavingsPacing {
  SavingsPacing._();

  /// Menghitung status dan kebutuhan setoran per hari atau per bulan.
  static PacingResult calculate({
    required int targetAmount,
    required int currentAmount,
    required String? deadlineLocalDate,
    required String todayLocalDate,
  }) {
    if (currentAmount >= targetAmount) {
      return const PacingResult(
        status: PacingStatus.achieved,
        remainingAmount: 0,
        daysRemaining: 0,
        requiredPerDay: 0,
        requiredPerMonth: 0,
      );
    }

    final remainingAmount = targetAmount - currentAmount;

    if (deadlineLocalDate == null || deadlineLocalDate.isEmpty) {
      return PacingResult(
        status: PacingStatus.noDeadline,
        remainingAmount: remainingAmount,
        daysRemaining: null,
        requiredPerDay: null,
        requiredPerMonth: null,
      );
    }

    final today = DateTime.tryParse(todayLocalDate);
    final deadline = DateTime.tryParse(deadlineLocalDate);

    if (today == null || deadline == null) {
      return PacingResult(
        status: PacingStatus.noDeadline,
        remainingAmount: remainingAmount,
        daysRemaining: null,
        requiredPerDay: null,
        requiredPerMonth: null,
      );
    }

    final diffDays = deadline.difference(today).inDays;
    if (diffDays <= 0) {
      return PacingResult(
        status: PacingStatus.overdue,
        remainingAmount: remainingAmount,
        daysRemaining: diffDays,
        requiredPerDay: remainingAmount,
        requiredPerMonth: remainingAmount,
      );
    }

    final requiredPerDay = (remainingAmount / diffDays).ceil();
    final monthsRemaining = (diffDays / 30.0).clamp(1.0, 120.0);
    final requiredPerMonth = (remainingAmount / monthsRemaining).ceil();

    return PacingResult(
      status: PacingStatus.onTrack,
      remainingAmount: remainingAmount,
      daysRemaining: diffDays,
      requiredPerDay: requiredPerDay,
      requiredPerMonth: requiredPerMonth,
    );
  }
}

class PacingResult {
  final PacingStatus status;
  final int remainingAmount;
  final int? daysRemaining;
  final int? requiredPerDay;
  final int? requiredPerMonth;

  const PacingResult({
    required this.status,
    required this.remainingAmount,
    this.daysRemaining,
    this.requiredPerDay,
    this.requiredPerMonth,
  });
}
