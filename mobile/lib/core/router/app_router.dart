import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/arena/presentation/screens/arena_screen.dart';
import '../../features/logs/presentation/screens/logs_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/setup/presentation/screens/setup_match_screen.dart';
import '../../features/replay/presentation/screens/replay_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Application routing configuration using GoRouter and StatefulShellRoute for persistent bottom navigation.
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/arena',
  routes: [
    // 1. Bottom Navigation Stateful Shell Route
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Branch 1: Live Arena
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/arena',
              builder: (context, state) => ArenaScreen(
                onOpenSetup: () => context.push('/setup'),
              ),
            ),
          ],
        ),

        // Branch 2: Past Matches Archive
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/logs',
              builder: (context, state) => const LogsScreen(),
            ),
          ],
        ),

        // Branch 3: Settings & API Keys
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),

    // 2. Full-Screen Match Setup Route
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/setup',
      builder: (context, state) => const SetupMatchScreen(),
    ),

    // 3. Full-Screen Replay Inspector Route
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/replay/:gameId',
      builder: (context, state) {
        final gameId = state.pathParameters['gameId'] ?? '';
        return ReplayScreen(gameId: gameId);
      },
    ),
  ],
);

class _ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _ScaffoldWithNavBar({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sports_esports_outlined),
            selectedIcon: Icon(Icons.sports_esports_rounded),
            label: 'Arena',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'Logs',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
