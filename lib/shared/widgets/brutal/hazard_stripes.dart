import 'package:flutter/material.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';

/// Pita garis diagonal kuning-hitam (Hazard Stripes) untuk peringatan mendesak.
class HazardStripes extends StatelessWidget {
  final double height;
  final double stripeWidth;
  final Color primaryColor;
  final Color secondaryColor;

  const HazardStripes({
    super.key,
    this.height = 12.0,
    this.stripeWidth = 12.0,
    this.primaryColor = BrutalTokens.warn,
    this.secondaryColor = BrutalTokens.ink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: secondaryColor,
            width: BrutalTokens.borderThin,
          ),
        ),
      ),
      child: CustomPaint(
        painter: _HazardPainter(
          stripeWidth: stripeWidth,
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
      ),
    );
  }
}

class _HazardPainter extends CustomPainter {
  final double stripeWidth;
  final Color primaryColor;
  final Color secondaryColor;

  _HazardPainter({
    required this.stripeWidth,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintPrimary = Paint()..color = primaryColor;
    final paintSecondary = Paint()..color = secondaryColor;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintPrimary);

    final path = Path();
    final double step = stripeWidth * 2;

    for (double x = -size.height; x < size.width + size.height; x += step) {
      path.reset();
      path.moveTo(x, size.height);
      path.lineTo(x + stripeWidth, size.height);
      path.lineTo(x + stripeWidth + size.height, 0);
      path.lineTo(x + size.height, 0);
      path.close();
      canvas.drawPath(path, paintSecondary);
    }
  }

  @override
  bool shouldRepaint(covariant _HazardPainter oldDelegate) {
    return oldDelegate.stripeWidth != stripeWidth ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}
