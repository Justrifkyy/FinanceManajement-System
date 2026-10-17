import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/backup/backup_restore_screen.dart';
import '../../features/budget/allocate_screen.dart';
import '../../features/budget/budget_screen.dart';
import '../../features/budget/manage_envelopes_screen.dart';
import '../../features/budget/subscriptions_screen.dart';
import '../../features/future/future_screen.dart';
import '../../features/future/portfolio_screen.dart';
import '../../features/home/fasting_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/settings/profile_screen.dart';
import '../../features/shell/main_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Beranda (Survival Dashboard)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeScreen(),
              ),
            ),
          ],
        ),
        // Tab 1: Alokasi (Budget Room)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/budget',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: BudgetScreen(),
              ),
            ),
          ],
        ),
        // Tab 2: Target & Impian (The Future)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/future',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: FutureScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
    // Detail Pages
    GoRoute(
      path: '/allocate',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final initialEnvelopeId = state.uri.queryParameters['envelopeId'];
        return AllocateScreen(initialEnvelopeId: initialEnvelopeId);
      },
    ),
    GoRoute(
      path: '/envelopes',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ManageEnvelopesScreen(),
    ),
    GoRoute(
      path: '/subscriptions',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SubscriptionsScreen(),
    ),
    GoRoute(
      path: '/profile',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/fasting',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FastingScreen(),
    ),
    GoRoute(
      path: '/portfolio',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PortfolioScreen(),
    ),
    GoRoute(
      path: '/backup',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BackupRestoreScreen(),
    ),
  ],
);
