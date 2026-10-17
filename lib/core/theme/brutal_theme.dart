import 'package:flutter/material.dart';
import 'brutal_tokens.dart';

@immutable
class BrutalTheme extends ThemeExtension<BrutalTheme> {
  final Color ink;
  final Color canvas;
  final Color paper;
  final Color safe;
  final Color warn;
  final Color danger;
  final Color needs;
  final Color wants;
  final Color buffer;
  final Color goal;
  final Color muted;
  final Color disabled;

  const BrutalTheme({
    required this.ink,
    required this.canvas,
    required this.paper,
    required this.safe,
    required this.warn,
    required this.danger,
    required this.needs,
    required this.wants,
    required this.buffer,
    required this.goal,
    required this.muted,
    required this.disabled,
  });

  factory BrutalTheme.light() {
    return const BrutalTheme(
      ink: BrutalTokens.ink,
      canvas: BrutalTokens.canvas,
      paper: BrutalTokens.paper,
      safe: BrutalTokens.safe,
      warn: BrutalTokens.warn,
      danger: BrutalTokens.danger,
      needs: BrutalTokens.needs,
      wants: BrutalTokens.wants,
      buffer: BrutalTokens.buffer,
      goal: BrutalTokens.goal,
      muted: BrutalTokens.muted,
      disabled: BrutalTokens.disabled,
    );
  }

  @override
  BrutalTheme copyWith({
    Color? ink,
    Color? canvas,
    Color? paper,
    Color? safe,
    Color? warn,
    Color? danger,
    Color? needs,
    Color? wants,
    Color? buffer,
    Color? goal,
    Color? muted,
    Color? disabled,
  }) {
    return BrutalTheme(
      ink: ink ?? this.ink,
      canvas: canvas ?? this.canvas,
      paper: paper ?? this.paper,
      safe: safe ?? this.safe,
      warn: warn ?? this.warn,
      danger: danger ?? this.danger,
      needs: needs ?? this.needs,
      wants: wants ?? this.wants,
      buffer: buffer ?? this.buffer,
      goal: goal ?? this.goal,
      muted: muted ?? this.muted,
      disabled: disabled ?? this.disabled,
    );
  }

  @override
  BrutalTheme lerp(ThemeExtension<BrutalTheme>? other, double t) {
    if (other is! BrutalTheme) return this;
    return BrutalTheme(
      ink: Color.lerp(ink, other.ink, t) ?? ink,
      canvas: Color.lerp(canvas, other.canvas, t) ?? canvas,
      paper: Color.lerp(paper, other.paper, t) ?? paper,
      safe: Color.lerp(safe, other.safe, t) ?? safe,
      warn: Color.lerp(warn, other.warn, t) ?? warn,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      needs: Color.lerp(needs, other.needs, t) ?? needs,
      wants: Color.lerp(wants, other.wants, t) ?? wants,
      buffer: Color.lerp(buffer, other.buffer, t) ?? buffer,
      goal: Color.lerp(goal, other.goal, t) ?? goal,
      muted: Color.lerp(muted, other.muted, t) ?? muted,
      disabled: Color.lerp(disabled, other.disabled, t) ?? disabled,
    );
  }
}

extension BuildContextBrutalTheme on BuildContext {
  BrutalTheme get brutal =>
      Theme.of(this).extension<BrutalTheme>() ?? BrutalTheme.light();
}
