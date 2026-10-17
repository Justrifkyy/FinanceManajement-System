import 'package:flutter/material.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';

class PageHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final VoidCallback onProfile;

  const PageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: BrutalTokens.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    color: BrutalTokens.ink,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onProfile,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: BrutalTokens.paper,
                borderRadius: BrutalTokens.radiusZero,
                border: Border.all(
                  color: BrutalTokens.ink,
                  width: BrutalTokens.borderBase,
                ),
                boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: BrutalTokens.ink,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final VoidCallback onBack;

  const DetailHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: BrutalTokens.warn,
                borderRadius: BrutalTokens.radiusZero,
                border: Border.all(
                  color: BrutalTokens.ink,
                  width: BrutalTokens.borderBase,
                ),
                boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: BrutalTokens.ink,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: BrutalTokens.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    color: BrutalTokens.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionTitle({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0, bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: BrutalTokens.fontUi,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: BrutalTokens.ink,
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: BrutalTokens.ink,
                      width: BrutalTokens.borderThin,
                    ),
                  ),
                ),
                child: Text(
                  action!.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: BrutalTokens.fontUi,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: BrutalTokens.ink,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
