import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Preset definition for the 11 high-contrast themes.
class AppThemePreset {
  final String id;
  final String name;
  final String description;
  final String badge;
  final Brightness brightness;
  final Color bgBase;
  final Color surfacePanel;
  final Color surfaceCard;
  final Color textPrimary;
  final Color textSecondary;
  final Color accentColor;
  final Color accentText;

  const AppThemePreset({
    required this.id,
    required this.name,
    required this.description,
    required this.badge,
    required this.brightness,
    required this.bgBase,
    required this.surfacePanel,
    required this.surfaceCard,
    required this.textPrimary,
    required this.textSecondary,
    required this.accentColor,
    required this.accentText,
  });

  /// Builds a complete Material Design 3 ThemeData from this preset.
  ThemeData toThemeData() {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accentColor,
      onPrimary: accentText,
      primaryContainer: isDark ? accentColor.withOpacity(0.2) : accentColor.withOpacity(0.12),
      onPrimaryContainer: isDark ? Colors.white : accentColor,
      secondary: accentColor,
      onSecondary: accentText,
      surface: bgBase,
      onSurface: textPrimary,
      surfaceContainerHighest: surfaceCard,
      surfaceContainerLow: surfacePanel,
      outline: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.12),
      error: const Color(0xFFEF4444),
      onError: Colors.white,
    );

    final textTheme = GoogleFonts.interTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bgBase,
      canvasColor: bgBase,
      cardColor: surfaceCard,
      dialogBackgroundColor: surfacePanel,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: bgBase,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.2,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfacePanel,
        selectedItemColor: accentColor,
        unselectedItemColor: textSecondary,
        elevation: 8,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfacePanel,
        indicatorColor: accentColor.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w600,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: textSecondary,
            fontWeight: FontWeight.w500,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? bgBase : surfaceCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.12),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accentColor, width: 1.5),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: textSecondary.withOpacity(0.7)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: accentText,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accentColor,
        inactiveTrackColor: accentColor.withOpacity(0.24),
        thumbColor: accentColor,
        overlayColor: accentColor.withOpacity(0.16),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
        thickness: 1,
      ),
    );
  }

  // 11 Theme Presets Matching Web Platform
  static const oledBlack = AppThemePreset(
    id: 'oled-black',
    name: 'OLED Pitch Black',
    description: '100% pure pitch black & monochrome.',
    badge: 'AMOLED Black',
    brightness: Brightness.dark,
    bgBase: Color(0xFF000000),
    surfacePanel: Color(0xFF0A0A0A),
    surfaceCard: Color(0xFF121212),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFA3A3A3),
    accentColor: Color(0xFFFFFFFF),
    accentText: Color(0xFF000000),
  );

  static const lightPure = AppThemePreset(
    id: 'light',
    name: 'Light Pure',
    description: 'Crisp, high-contrast clean white & slate.',
    badge: 'Pure Light',
    brightness: Brightness.light,
    bgBase: Color(0xFFF8FAFC),
    surfacePanel: Color(0xFFFFFFFF),
    surfaceCard: Color(0xFFF1F5F9),
    textPrimary: Color(0xFF090D16),
    textSecondary: Color(0xFF64748B),
    accentColor: Color(0xFF4F46E5),
    accentText: Color(0xFFFFFFFF),
  );

  static const catppuccinLatte = AppThemePreset(
    id: 'catppuccin-latte',
    name: 'Catppuccin Latte',
    description: 'Warm, cozy pastel light mode with mauve.',
    badge: 'Pastel Light',
    brightness: Brightness.light,
    bgBase: Color(0xFFEFF1F5),
    surfacePanel: Color(0xFFFFFFFF),
    surfaceCard: Color(0xFFE6E9EF),
    textPrimary: Color(0xFF1E1E2E),
    textSecondary: Color(0xFF6C6F85),
    accentColor: Color(0xFF8839EF),
    accentText: Color(0xFFFFFFFF),
  );

  static const catppuccinMocha = AppThemePreset(
    id: 'catppuccin',
    name: 'Catppuccin Mocha',
    description: 'Soothing warm chocolate-slate with mauve.',
    badge: 'Pastel Cozy',
    brightness: Brightness.dark,
    bgBase: Color(0xFF181825),
    surfacePanel: Color(0xFF1E1E2E),
    surfaceCard: Color(0xFF313244),
    textPrimary: Color(0xFFCDD6F4),
    textSecondary: Color(0xFF6C7086),
    accentColor: Color(0xFFCBA6F7),
    accentText: Color(0xFF11111B),
  );

  static const dracula = AppThemePreset(
    id: 'dracula',
    name: 'Dracula Gothic',
    description: 'Iconic vampire dark with vibrant purple.',
    badge: 'Vibrant Dark',
    brightness: Brightness.dark,
    bgBase: Color(0xFF1E1F29),
    surfacePanel: Color(0xFF282A36),
    surfaceCard: Color(0xFF44475A),
    textPrimary: Color(0xFFF8F8F2),
    textSecondary: Color(0xFF6272A4),
    accentColor: Color(0xFFBD93F9),
    accentText: Color(0xFF282A36),
  );

  static const nord = AppThemePreset(
    id: 'nord',
    name: 'Nordic Frost',
    description: 'Clean Arctic polar night with ice-blue frost.',
    badge: 'Arctic Frost',
    brightness: Brightness.dark,
    bgBase: Color(0xFF242933),
    surfacePanel: Color(0xFF2E3440),
    surfaceCard: Color(0xFF3B4252),
    textPrimary: Color(0xFFECEFF4),
    textSecondary: Color(0xFF7B88A1),
    accentColor: Color(0xFF88C0D0),
    accentText: Color(0xFF2E3440),
  );

  static const gruvbox = AppThemePreset(
    id: 'gruvbox',
    name: 'Gruvbox Retro',
    description: 'Warm earthy groove with retro gold & orange.',
    badge: 'Warm Retro',
    brightness: Brightness.dark,
    bgBase: Color(0xFF1D2021),
    surfacePanel: Color(0xFF282828),
    surfaceCard: Color(0xFF3C3836),
    textPrimary: Color(0xFFEBDBB2),
    textSecondary: Color(0xFF928374),
    accentColor: Color(0xFFFABD2F),
    accentText: Color(0xFF282828),
  );

  static const rosePine = AppThemePreset(
    id: 'rose-pine',
    name: 'Rosé Pine',
    description: 'Aesthetic moody wine & plum with love-rose.',
    badge: 'Aesthetic Plum',
    brightness: Brightness.dark,
    bgBase: Color(0xFF14121F),
    surfacePanel: Color(0xFF191724),
    surfaceCard: Color(0xFF26233A),
    textPrimary: Color(0xFFE0DEF4),
    textSecondary: Color(0xFF6E6A86),
    accentColor: Color(0xFFEB6F92),
    accentText: Color(0xFF191724),
  );

  static const emerald = AppThemePreset(
    id: 'emerald',
    name: 'Emerald Matrix',
    description: 'Cyberpunk obsidian with vivid hacker green.',
    badge: 'Cyber Green',
    brightness: Brightness.dark,
    bgBase: Color(0xFF060A08),
    surfacePanel: Color(0xFF0D1611),
    surfaceCard: Color(0xFF15231B),
    textPrimary: Color(0xFFE6F7EF),
    textSecondary: Color(0xFF4B7A62),
    accentColor: Color(0xFF10B981),
    accentText: Color(0xFF060A08),
  );

  static const tokyoNight = AppThemePreset(
    id: 'tokyo-night',
    name: 'Tokyo Night',
    description: 'Neon noir Japanese city night with cyan & violet.',
    badge: 'Neon Noir',
    brightness: Brightness.dark,
    bgBase: Color(0xFF13141F),
    surfacePanel: Color(0xFF1A1B26),
    surfaceCard: Color(0xFF24283B),
    textPrimary: Color(0xFFC0CAF5),
    textSecondary: Color(0xFF565F89),
    accentColor: Color(0xFF7AA2F7),
    accentText: Color(0xFF1A1B26),
  );

  static const modernSlate = AppThemePreset(
    id: 'modern-slate',
    name: 'Modern Slate',
    description: 'Dark titanium slate with electric sky.',
    badge: 'Dark Slate',
    brightness: Brightness.dark,
    bgBase: Color(0xFF080C14),
    surfacePanel: Color(0xFF0F172A),
    surfaceCard: Color(0xFF1E293B),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF64748B),
    accentColor: Color(0xFF38BDF8),
    accentText: Color(0xFF080C14),
  );

  static const List<AppThemePreset> all = [
    modernSlate,
    oledBlack,
    lightPure,
    catppuccinLatte,
    catppuccinMocha,
    dracula,
    nord,
    gruvbox,
    rosePine,
    emerald,
    tokyoNight,
  ];

  static AppThemePreset fromId(String id) {
    return all.firstWhere(
      (p) => p.id == id,
      orElse: () => modernSlate,
    );
  }
}
