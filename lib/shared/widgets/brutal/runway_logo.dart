import 'dart:math';
import 'package:flutter/material.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';

/// Widget Logo Garis Tiga (///) khas Runway Finance.
/// Dapat dirender tajam pada berbagai ukuran menggunakan CustomPainter.
class RunwayThreeLines extends StatelessWidget {
  final double size;
  final Color fillColor;
  final Color borderColor;
  final double? borderWidth;
  final double slant;

  const RunwayThreeLines({
    super.key,
    this.size = 48.0,
    this.fillColor = BrutalTokens.warn,
    this.borderColor = BrutalTokens.ink,
    this.borderWidth,
    this.slant = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _RunwayLinesPainter(
        fillColor: fillColor,
        borderColor: borderColor,
        borderWidth: borderWidth ?? (size * 0.035).clamp(1.5, 6.0),
        slant: slant,
      ),
    );
  }
}

class _RunwayLinesPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double slant;

  _RunwayLinesPainter({
    required this.fillColor,
    required this.borderColor,
    required this.borderWidth,
    required this.slant,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2.0;
    final cy = size.height / 2.0;

    final halfLen = size.height * 0.32;
    final barWidth = size.width * 0.12;
    final spacing = size.width * 0.22;

    // Arah vector kemiringan
    final vx = slant;
    const vy = -1.0;
    final vNorm = sqrt(vx * vx + vy * vy);
    final ux = vx / vNorm;
    final uy = vy / vNorm;

    // Normal vector tegak lurus kemiringan
    final nx = -uy;
    final ny = ux;

    final centers = [-spacing, 0.0, spacing];

    final linePaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = barWidth
      ..strokeCap = StrokeCap.round;

    final outlinePaint = borderWidth > 0
        ? (Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = barWidth + borderWidth * 2
          ..strokeCap = StrokeCap.round)
        : null;

    for (final dCenter in centers) {
      final p1x = cx + dCenter * nx - halfLen * ux;
      final p1y = cy + dCenter * ny - halfLen * uy;
      final p2x = cx + dCenter * nx + halfLen * ux;
      final p2y = cy + dCenter * ny + halfLen * uy;

      final p1 = Offset(p1x, p1y);
      final p2 = Offset(p2x, p2y);

      // Gambar border outline hitam tebal jika aktif
      if (outlinePaint != null) {
        canvas.drawLine(p1, p2, outlinePaint);
      }

      // Gambar isi warna
      canvas.drawLine(p1, p2, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RunwayLinesPainter oldDelegate) {
    return oldDelegate.fillColor != fillColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.slant != slant;
  }
}

/// Logo Lengkap Runway Finance (Garis Tiga + Teks Judul)
class RunwayFullLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final bool isDark;

  const RunwayFullLogo({
    super.key,
    this.iconSize = 36.0,
    this.fontSize = 24.0,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? BrutalTokens.paper : BrutalTokens.ink;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RunwayThreeLines(size: iconSize),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'RUNWAY',
                  style: TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: textColor,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '///',
                  style: TextStyle(
                    fontFamily: BrutalTokens.fontNumbers,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w900,
                    color: BrutalTokens.warn,
                    height: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'FINANCE',
              style: TextStyle(
                fontFamily: BrutalTokens.fontUi,
                fontSize: fontSize * 0.45,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
                color: isDark ? BrutalTokens.disabled : BrutalTokens.muted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Logo Garis Tiga dengan Animasi Slash Kinetik & Staggered Entry
class AnimatedRunwayThreeLines extends StatelessWidget {
  final double size;
  final double progress; // 0.0 hingga 1.0
  final Color fillColor;
  final Color borderColor;
  final double? borderWidth;
  final double slant;

  const AnimatedRunwayThreeLines({
    super.key,
    this.size = 110.0,
    required this.progress,
    this.fillColor = BrutalTokens.warn,
    this.borderColor = BrutalTokens.ink,
    this.borderWidth,
    this.slant = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _AnimatedRunwayLinesPainter(
        progress: progress.clamp(0.0, 1.0),
        fillColor: fillColor,
        borderColor: borderColor,
        borderWidth: borderWidth ?? (size * 0.038).clamp(2.0, 6.0),
        slant: slant,
      ),
    );
  }
}

class _AnimatedRunwayLinesPainter extends CustomPainter {
  final double progress;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double slant;

  _AnimatedRunwayLinesPainter({
    required this.progress,
    required this.fillColor,
    required this.borderColor,
    required this.borderWidth,
    required this.slant,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2.0;
    final cy = size.height / 2.0;

    final halfLen = size.height * 0.34;
    final barWidth = size.width * 0.125;
    final spacing = size.width * 0.22;

    final vx = slant;
    const vy = -1.0;
    final vNorm = sqrt(vx * vx + vy * vy);
    final ux = vx / vNorm;
    final uy = vy / vNorm;

    final nx = -uy;
    final ny = ux;

    final centers = [-spacing, 0.0, spacing];

    final linePaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = barWidth
      ..strokeCap = StrokeCap.round;

    final outlinePaint = borderWidth > 0
        ? (Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = barWidth + borderWidth * 2
          ..strokeCap = StrokeCap.round)
        : null;

    for (int i = 0; i < 3; i++) {
      final start = i * 0.18;
      final end = (start + 0.45).clamp(0.0, 1.0);
      if (progress <= start) continue;

      final t = ((progress - start) / (end - start)).clamp(0.0, 1.0);
      final curveVal = Curves.easeOutBack.transform(t);

      // Stagger slash offset: bar meluncur dari arah miring atas
      final dropOffset = (1.0 - curveVal) * size.height * 0.7;
      final dCenter = centers[i];

      final p1x = cx + dCenter * nx - (halfLen * curveVal) * ux + dropOffset * ux;
      final p1y = cy + dCenter * ny - (halfLen * curveVal) * uy + dropOffset * uy;
      final p2x = cx + dCenter * nx + (halfLen * curveVal) * ux + dropOffset * ux;
      final p2y = cy + dCenter * ny + (halfLen * curveVal) * uy + dropOffset * uy;

      final p1 = Offset(p1x, p1y);
      final p2 = Offset(p2x, p2y);

      if (outlinePaint != null) {
        canvas.drawLine(p1, p2, outlinePaint);
      }
      canvas.drawLine(p1, p2, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedRunwayLinesPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.slant != slant;
  }
}

