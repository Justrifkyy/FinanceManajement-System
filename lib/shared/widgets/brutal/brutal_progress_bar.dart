import 'package:flutter/material.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';

class BrutalProgressBar extends StatelessWidget {
  final double value; // 0.0 sampai 100.0
  final double height;
  final Color fillColor;
  final Color backgroundColor;

  const BrutalProgressBar({
    super.key,
    required this.value,
    this.height = 15.0,
    this.fillColor = BrutalTokens.ink,
    this.backgroundColor = BrutalTokens.paper,
  });

  @override
  Widget build(BuildContext context) {
    final clampValue = value.clamp(0.0, 100.0) / 100.0;

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BrutalTokens.radiusZero,
        border: Border.all(
          color: BrutalTokens.ink,
          width: BrutalTokens.borderThin,
        ),
      ),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: clampValue,
        child: Container(
          color: fillColor,
        ),
      ),
    );
  }
}
