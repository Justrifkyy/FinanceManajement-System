import 'package:flutter/material.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';

/// Toggle switch neo-brutalism persegi dengan animasi geser fisik
class BrutalToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const BrutalToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 48,
        height: 27,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? BrutalTokens.safe : BrutalTokens.disabled,
          borderRadius: BrutalTokens.radiusZero,
          border: Border.all(
            color: BrutalTokens.ink,
            width: BrutalTokens.borderThin,
          ),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 17,
          height: 17,
          decoration: BoxDecoration(
            color: BrutalTokens.paper,
            borderRadius: BrutalTokens.radiusZero,
            border: Border.all(
              color: BrutalTokens.ink,
              width: BrutalTokens.borderThin,
            ),
          ),
        ),
      ),
    );
  }
}
