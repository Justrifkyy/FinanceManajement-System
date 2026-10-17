import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runway_finance/core/constants/strings.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/domain/runway.dart';
import 'package:runway_finance/providers/runway_provider.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_card.dart';
import 'package:runway_finance/shared/widgets/brutal/stamp.dart';

/// Health Bar utama di Beranda (Survival Dashboard).
/// Menjawab pertanyaan: "Berapa hari saya bisa bertahan hidup dengan uang yang ada sekarang?"
class HealthBar extends ConsumerWidget {
  const HealthBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runwayAsync = ref.watch(runwayProvider);

    return runwayAsync.when(
      data: (state) => _buildCard(context, state),
      loading: () => const BrutalCard(
        backgroundColor: BrutalTokens.paper,
        child: SizedBox(
          height: 180,
          child: Center(
            child: CircularProgressIndicator(color: BrutalTokens.ink),
          ),
        ),
      ),
      error: (err, stack) => BrutalCard(
        backgroundColor: BrutalTokens.danger,
        child: Text(
          'Gagal memuat status runway: $err',
          style: const TextStyle(
            color: BrutalTokens.ink,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, RunwayState state) {
    final Color bgColor;
    final String stampText;
    final String description;

    switch (state.status) {
      case HealthStatus.safe:
        bgColor = BrutalTokens.safe;
        stampText = AppStrings.statusSafe;
        description = AppStrings.statusSafeDesc;
        break;
      case HealthStatus.warning:
        bgColor = BrutalTokens.warn;
        stampText = AppStrings.statusWarning;
        description = AppStrings.statusWarningDesc;
        break;
      case HealthStatus.danger:
        bgColor = BrutalTokens.danger;
        stampText = AppStrings.statusDanger;
        description = AppStrings.statusDangerDesc;
        break;
      case HealthStatus.noData:
        bgColor = BrutalTokens.paper;
        stampText = AppStrings.statusNoData;
        description = AppStrings.statusNoDataDesc;
        break;
    }

    return BrutalCard(
      backgroundColor: bgColor,
      borderWidth: BrutalTokens.borderHeavy,
      shadowOffset: BrutalTokens.shadowLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RUNWAY KAMU',
                style: TextStyle(
                  fontFamily: BrutalTokens.fontUi,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: BrutalTokens.ink,
                  letterSpacing: 1.0,
                ),
              ),
              Stamp(
                text: stampText,
                backgroundColor: state.status == HealthStatus.noData
                    ? BrutalTokens.disabled
                    : BrutalTokens.paper,
                isRotated: true,
              ),
            ],
          ),
          const SizedBox(height: BrutalTokens.spaceMd),
          if (state.runwayDays != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${state.runwayDays}',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(width: BrutalTokens.spaceSm),
                const Text(
                  AppStrings.days,
                  style: TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: BrutalTokens.ink,
                  ),
                ),
              ],
            ),
          ] else ...[
            const Text(
              '---',
              style: TextStyle(
                fontFamily: BrutalTokens.fontNumbers,
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: BrutalTokens.ink,
              ),
            ),
          ],
          const SizedBox(height: BrutalTokens.spaceSm),
          Text(
            description,
            style: const TextStyle(
              fontFamily: BrutalTokens.fontUi,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: BrutalTokens.ink,
            ),
          ),
        ],
      ),
    );
  }
}
