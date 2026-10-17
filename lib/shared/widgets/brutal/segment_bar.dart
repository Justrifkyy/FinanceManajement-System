import 'package:flutter/material.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';

/// 10-blok segment bar (indikator baterai fisik runway)
class SegmentBar extends StatelessWidget {
  final int totalSegments;
  final int filledSegments;

  const SegmentBar({
    super.key,
    this.totalSegments = 10,
    required this.filledSegments,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSegments, (index) {
        final isFilled = index < filledSegments;
        return Expanded(
          child: Container(
            height: 15,
            margin: EdgeInsets.only(right: index < totalSegments - 1 ? 3.0 : 0.0),
            decoration: BoxDecoration(
              color: isFilled ? BrutalTokens.ink : BrutalTokens.paper,
              borderRadius: BrutalTokens.radiusZero,
              border: Border.all(
                color: BrutalTokens.ink,
                width: BrutalTokens.borderThin,
              ),
            ),
          ),
        );
      }),
    );
  }
}
