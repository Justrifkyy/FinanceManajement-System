import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/shared/widgets/brutal/top_brand.dart';
import '../transaction/transaction_entry_sheet.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  void _openTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TransactionEntrySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      backgroundColor: BrutalTokens.canvas,
      body: SafeArea(
        child: Column(
          children: [
            const TopBrand(),
            Expanded(child: navigationShell),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 82,
        decoration: const BoxDecoration(
          color: BrutalTokens.paper,
          border: Border(
            top: BorderSide(
              color: BrutalTokens.ink,
              width: BrutalTokens.borderHeavy,
            ),
          ),
        ),
        child: Row(
          children: [
            // Tab 0: BERANDA
            _buildNavTab(
              index: 0,
              label: 'BERANDA',
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              isActive: currentIndex == 0,
            ),

            // Tab 1: ALOKASI
            _buildNavTab(
              index: 1,
              label: 'ALOKASI',
              icon: Icons.account_balance_wallet_outlined,
              activeIcon: Icons.account_balance_wallet,
              isActive: currentIndex == 1,
            ),

            // Centered FAB (64x64)
            Container(
              width: 78,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => _openTransactionModal(context),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: BrutalTokens.warn,
                    borderRadius: BrutalTokens.radiusZero,
                    border: Border.all(
                      color: BrutalTokens.ink,
                      width: BrutalTokens.borderHeavy,
                    ),
                    boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowLg),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 32,
                    color: BrutalTokens.ink,
                  ),
                ),
              ),
            ),

            // Tab 2: TARGET
            _buildNavTab(
              index: 2,
              label: 'TARGET',
              icon: Icons.track_changes,
              activeIcon: Icons.track_changes,
              isActive: currentIndex == 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? BrutalTokens.warn : BrutalTokens.paper,
            border: const Border(
              right: BorderSide(
                color: BrutalTokens.ink,
                width: BrutalTokens.borderThin,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: BrutalTokens.ink,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: BrutalTokens.fontUi,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: BrutalTokens.ink,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
