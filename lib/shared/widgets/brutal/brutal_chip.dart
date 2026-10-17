import 'package:flutter/material.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';

/// Chip filter atau pemilih amplop dengan gaya neo-brutalism.
class BrutalChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color selectedColor;
  final Widget? icon;

  const BrutalChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.selectedColor = BrutalTokens.warn,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: BrutalTokens.spaceMd,
          vertical: BrutalTokens.spaceSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : BrutalTokens.paper,
          borderRadius: BrutalTokens.radiusZero,
          border: Border.all(
            color: BrutalTokens.ink,
            width: BrutalTokens.borderThin,
          ),
          boxShadow: isSelected
              ? BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: BrutalTokens.spaceXs),
            ],
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontFamily: BrutalTokens.fontUi,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: BrutalTokens.ink,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
