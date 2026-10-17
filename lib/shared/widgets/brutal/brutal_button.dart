import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';

enum BrutalButtonVariant {
  primary, // warn
  safe, // safe
  danger, // danger
  neutral, // paper
}

/// Tombol Neo-Brutalism dengan efek tekan 'tenggelam' (offset bergeser & bayangan lenyap).
class BrutalButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final BrutalButtonVariant variant;
  final Widget? icon;
  final bool isFullWidth;
  final EdgeInsetsGeometry padding;

  const BrutalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = BrutalButtonVariant.primary,
    this.icon,
    this.isFullWidth = false,
    this.padding = const EdgeInsets.symmetric(
      horizontal: BrutalTokens.spaceXl,
      vertical: BrutalTokens.spaceMd,
    ),
  });

  @override
  State<BrutalButton> createState() => _BrutalButtonState();
}

class _BrutalButtonState extends State<BrutalButton> {
  bool _isPressed = false;

  Color _getBackgroundColor() {
    if (widget.onPressed == null) return BrutalTokens.disabled;
    switch (widget.variant) {
      case BrutalButtonVariant.primary:
        return BrutalTokens.warn;
      case BrutalButtonVariant.safe:
        return BrutalTokens.safe;
      case BrutalButtonVariant.danger:
        return BrutalTokens.danger;
      case BrutalButtonVariant.neutral:
        return BrutalTokens.paper;
    }
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
    widget.onPressed!();
  }

  void _handleTapCancel() {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    const shadowOffset = BrutalTokens.shadowMd;
    final isEnabled = widget.onPressed != null;

    final content = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BrutalTokens.radiusZero,
        border: Border.all(
          color: isEnabled ? BrutalTokens.ink : BrutalTokens.disabledText,
          width: BrutalTokens.borderBase,
        ),
        boxShadow: (isEnabled && !_isPressed)
            ? BrutalTokens.hardShadow(offset: shadowOffset)
            : null,
      ),
      child: Row(
        mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            widget.icon!,
            const SizedBox(width: BrutalTokens.spaceSm),
          ],
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.text.toUpperCase(),
                maxLines: 1,
                style: TextStyle(
                  fontFamily: BrutalTokens.fontUi,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: isEnabled ? BrutalTokens.ink : BrutalTokens.disabledText,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Transform.translate(
        offset: _isPressed ? const Offset(shadowOffset, shadowOffset) : Offset.zero,
        child: content,
      ),
    );
  }
}
