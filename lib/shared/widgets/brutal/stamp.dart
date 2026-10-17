import 'package:flutter/material.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';

/// Stempel status neo-brutalism (misal: AMAN, WASPADA, BAHAYA).
class Stamp extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final bool isRotated;

  const Stamp({
    super.key,
    required this.text,
    this.backgroundColor = BrutalTokens.warn,
    this.textColor = BrutalTokens.ink,
    this.isRotated = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BrutalTokens.spaceMd,
        vertical: BrutalTokens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BrutalTokens.radiusZero,
        border: Border.all(
          color: BrutalTokens.ink,
          width: BrutalTokens.borderBase,
        ),
      ),
      child: Text(
        text.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: BrutalTokens.fontUi,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: textColor,
          letterSpacing: 1.0,
        ),
      ),
    );

    if (isRotated) {
      return Transform.rotate(
        angle: -0.035, // ~ -2 derajat
        child: content,
      );
    }

    return content;
  }
}
