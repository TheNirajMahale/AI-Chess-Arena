import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme_notifier.dart';

/// Main MaterialApp with Riverpod dynamic theming and GoRouter navigation.
class ChessArenaApp extends ConsumerWidget {
  const ChessArenaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePreset = ref.watch(
      appSettingsProvider.select((s) => s.themePreset),
    );

    return MaterialApp.router(
      title: 'AI Chess Arena',
      debugShowCheckedModeBanner: false,
      theme: themePreset.toThemeData(),
      routerConfig: appRouter,
    );
  }
}
