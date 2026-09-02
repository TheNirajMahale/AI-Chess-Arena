import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme_presets.dart';
import '../../core/theme/board_themes.dart';
import '../../core/theme/theme_notifier.dart';

/// Draggable modal sheet calibrated to show all 6 chessboard colorways and at least 3 UI app theme presets on initial open with live board preview.
class ThemePickerSheet extends ConsumerWidget {
  const ThemePickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => const ThemePickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(appSettingsProvider);
    final themeNotifier = ref.read(appSettingsProvider.notifier);
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.58,
      minChildSize: 0.32,
      maxChildSize: 0.90,
      snap: true,
      snapSizes: const [0.58, 0.90],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // 1. Compact Drag Handle & Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 10, 2),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.dividerTheme.color?.withOpacity(0.6) ?? Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.palette_outlined, size: 19),
                            const SizedBox(width: 6),
                            Text(
                              'Themes & Live Board Preview',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.5,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 19),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // 2. Scrollable Content (Board Themes on top + 3+ UI Presets directly visible)
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  children: [
                    // Section 1: Chessboard Colorways (6)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chessboard Palette (6)',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                        Text(
                          'Live preview above',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        childAspectRatio: 2.3,
                      ),
                      itemCount: BoardTheme.all.length,
                      itemBuilder: (context, index) {
                        final b = BoardTheme.all[index];
                        final isSelected = themeState.boardTheme.id == b.id;

                        return InkWell(
                          onTap: () => themeNotifier.setBoardTheme(b),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                                width: 1.8,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Mini 2x2 board preview
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(child: Container(color: b.lightSquare)),
                                            Expanded(child: Container(color: b.darkSquare)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(child: Container(color: b.darkSquare)),
                                            Expanded(child: Container(color: b.lightSquare)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    b.name,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // Section 2: UI Color Schemes (11 Presets)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'UI App Themes (11 Presets)',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                        Text(
                          'Drag up for all 11',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: AppThemePreset.all.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final p = AppThemePreset.all[index];
                        final isSelected = themeState.themePreset.id == p.id;

                        return InkWell(
                          onTap: () => themeNotifier.setThemePreset(p),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                              color: p.bgBase,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? p.accentColor : Colors.grey.withOpacity(0.25),
                                width: isSelected ? 2.0 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Palette Preview Dots
                                Row(
                                  children: [
                                    _ColorDot(color: p.bgBase, borderColor: Colors.grey),
                                    _ColorDot(color: p.surfaceCard, borderColor: Colors.grey),
                                    _ColorDot(color: p.accentColor),
                                  ],
                                ),
                                const SizedBox(width: 10),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            p.name,
                                            style: TextStyle(
                                              color: p.textPrimary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: p.accentColor.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              p.badge,
                                              style: TextStyle(
                                                fontSize: 8.5,
                                                fontWeight: FontWeight.w600,
                                                color: p.accentColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        p.description,
                                        style: TextStyle(
                                          color: p.textSecondary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_circle_rounded, color: p.accentColor, size: 17),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final Color? borderColor;

  const _ColorDot({required this.color, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 3),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor ?? Colors.transparent, width: 0.8),
      ),
    );
  }
}
