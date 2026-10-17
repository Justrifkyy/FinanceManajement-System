import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/date_helper.dart';
import '../domain/runway.dart';
import 'repository_providers.dart';

class RunwayState {
  final int liquidCash;
  final int? avgDailySpend;
  final int? runwayDays;
  final HealthStatus status;

  const RunwayState({
    required this.liquidCash,
    required this.avgDailySpend,
    required this.runwayDays,
    required this.status,
  });
}

final runwayProvider = StreamProvider<RunwayState>((ref) async* {
  final envelopeRepo = ref.watch(envelopeRepositoryProvider);
  final transactionRepo = ref.watch(transactionRepositoryProvider);

  // Watch stream liquid cash
  await for (final liquidCash in envelopeRepo.watchLiquidCash()) {
    final today = DateHelper.todayLocalDateString();
    final todayDate = DateTime.tryParse(today) ?? DateTime.now();
    final thirtyDaysAgo = todayDate.subtract(const Duration(days: 30));
    final fromDate = DateHelper.toLocalDateString(thirtyDaysAgo);

    final totalSpending = await transactionRepo.getSpendingBetween(fromDate, today);
    final firstTxDateStr = await transactionRepo.getFirstTransactionLocalDate();

    int daysSinceFirst = 30;
    if (firstTxDateStr != null) {
      final firstTxDate = DateTime.tryParse(firstTxDateStr);
      if (firstTxDate != null) {
        daysSinceFirst = todayDate.difference(firstTxDate).inDays + 1;
      }
    }

    final avgDailySpend = RunwayCalculator.calculateAvgDailySpend(
      totalSpending30Days: totalSpending,
      daysSinceFirstTransaction: daysSinceFirst,
    );

    final runwayDays = RunwayCalculator.calculateRunwayDays(
      liquidCash: liquidCash,
      avgDailySpend: avgDailySpend,
    );

    final status = RunwayCalculator.determineHealthStatus(runwayDays);

    yield RunwayState(
      liquidCash: liquidCash,
      avgDailySpend: avgDailySpend,
      runwayDays: runwayDays,
      status: status,
    );
  }
});
