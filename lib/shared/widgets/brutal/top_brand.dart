import 'package:flutter/material.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';

/// Top bar hitam dengan logo: RUNWAY /// FINANCE
class TopBrand extends StatelessWidget {
  const TopBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: BrutalTokens.spaceLg),
      color: BrutalTokens.ink,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'RUNWAY ',
                style: TextStyle(
                  fontFamily: BrutalTokens.fontUi,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: BrutalTokens.paper,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                '///',
                style: TextStyle(
                  fontFamily: BrutalTokens.fontUi,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: BrutalTokens.warn,
                ),
              ),
            ],
          ),
          Text(
            'FINANCE',
            style: TextStyle(
              fontFamily: BrutalTokens.fontUi,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: BrutalTokens.paper,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}
