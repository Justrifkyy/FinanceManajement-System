import 'package:flutter/material.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';

/// Kartu Neo-Brutalism dengan border tebal dan hard shadow tanpa blur.
class BrutalCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double shadowOffset;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const BrutalCard({
    super.key,
    required this.child,
    this.backgroundColor = BrutalTokens.paper,
    this.borderColor = BrutalTokens.ink,
    this.borderWidth = BrutalTokens.borderBase,
    this.shadowOffset = BrutalTokens.shadowMd,
    this.padding = const EdgeInsets.all(BrutalTokens.spaceLg),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BrutalTokens.radiusZero,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: shadowOffset > 0
            ? BrutalTokens.hardShadow(offset: shadowOffset, color: borderColor)
            : null,
      ),
      padding: padding,
      child: child,
    );

    if (onTap == null) {
      return cardContent;
    }

    return GestureDetector(
      onTap: onTap,
      child: cardContent,
    );
  }
}
