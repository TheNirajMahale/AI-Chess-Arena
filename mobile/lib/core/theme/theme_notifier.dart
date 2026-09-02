import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme_presets.dart';
import 'board_themes.dart';
import '../constants/api_endpoints.dart';

class AppSettingsState {
  final AppThemePreset themePreset;
  final BoardTheme boardTheme;
  final String baseUrl;
  final String wsUrl;

  const AppSettingsState({
    required this.themePreset,
    required this.boardTheme,
    required this.baseUrl,
    required this.wsUrl,
  });

  AppSettingsState copyWith({
    AppThemePreset? themePreset,
    BoardTheme? boardTheme,
    String? baseUrl,
    String? wsUrl,
  }) {
    return AppSettingsState(
      themePreset: themePreset ?? this.themePreset,
      boardTheme: boardTheme ?? this.boardTheme,
      baseUrl: baseUrl ?? this.baseUrl,
      wsUrl: wsUrl ?? this.wsUrl,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettingsState> {
  static const String _keyThemeId = 'pref_app_theme_id';
  static const String _keyBoardThemeId = 'pref_board_theme_id';
  static const String _keyBaseUrl = 'pref_api_base_url';

  AppSettingsNotifier()
      : super(
          const AppSettingsState(
            themePreset: AppThemePreset.modernSlate,
            boardTheme: BoardTheme.modernSlate,
            baseUrl: ApiEndpoints.defaultBaseUrl,
            wsUrl: ApiEndpoints.defaultWsUrl,
          ),
        ) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeId = prefs.getString(_keyThemeId);
      final boardThemeId = prefs.getString(_keyBoardThemeId);
      final savedBaseUrl = prefs.getString(_keyBaseUrl);

      final theme = themeId != null ? AppThemePreset.fromId(themeId) : AppThemePreset.modernSlate;
      final board = boardThemeId != null ? BoardTheme.fromId(boardThemeId) : BoardTheme.modernSlate;
      final baseUrl = savedBaseUrl ?? ApiEndpoints.defaultBaseUrl;
      final wsUrl = _deriveWsUrl(baseUrl);

      state = AppSettingsState(
        themePreset: theme,
        boardTheme: board,
        baseUrl: baseUrl,
        wsUrl: wsUrl,
      );
    } catch (_) {}
  }

  String _deriveWsUrl(String baseUrl) {
    var clean = baseUrl.trim();
    if (clean.endsWith('/')) {
      clean = clean.substring(0, clean.length - 1);
    }
    if (clean.startsWith('https://')) {
      clean = 'wss://${clean.substring(8)}';
    } else if (clean.startsWith('http://')) {
      clean = 'ws://${clean.substring(7)}';
    } else if (!clean.startsWith('ws://') && !clean.startsWith('wss://')) {
      clean = 'ws://$clean';
    }
    return '$clean/ws/game';
  }

  Future<void> setThemePreset(AppThemePreset preset) async {
    state = state.copyWith(themePreset: preset);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeId, preset.id);
  }

  Future<void> setBoardTheme(BoardTheme board) async {
    state = state.copyWith(boardTheme: board);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBoardThemeId, board.id);
  }

  Future<void> setBaseUrl(String newBaseUrl) async {
    final wsUrl = _deriveWsUrl(newBaseUrl);
    state = state.copyWith(baseUrl: newBaseUrl, wsUrl: wsUrl);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBaseUrl, newBaseUrl);
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettingsState>(
  (ref) => AppSettingsNotifier(),
);
