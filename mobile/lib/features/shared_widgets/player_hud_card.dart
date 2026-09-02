import 'package:flutter/material.dart';
import '../../core/utils/material_eval.dart';
import '../../data/models/models.dart';

/// HUD scoreboard card representing a player, their model info, captured rack, and active thinking status.
class PlayerHudCard extends StatelessWidget {
  final PlayerConfig? config;
  final PlayerColor color;
  final bool isThinking;
  final bool isTurn;
  final List<String> capturedPieces;
  final int? materialAdvantage;
  final String? lastMoveSan;
  final int? lastMoveDurationMs;

  const PlayerHudCard({
    super.key,
    this.config,
    required this.color,
    this.isThinking = false,
    this.isTurn = false,
    this.capturedPieces = const [],
    this.materialAdvantage,
    this.lastMoveSan,
    this.lastMoveDurationMs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWhite = color == PlayerColor.white;
    final playerName = config?.name ?? (isWhite ? 'White Player' : 'Black Player');
    final modelId = config?.modelId ?? 'Not Configured';
    final providerName = config?.provider.displayName ?? 'AI';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isTurn
            ? theme.colorScheme.primary.withOpacity(0.08)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isThinking
              ? theme.colorScheme.primary
              : isTurn
                  ? theme.colorScheme.primary.withOpacity(0.4)
                  : theme.dividerTheme.color ?? Colors.transparent,
          width: isThinking ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // 1. Color Indicator Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isWhite ? Colors.white : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isWhite ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              isWhite ? '♔' : '♚',
              style: TextStyle(
                fontSize: 20,
                color: isWhite ? const Color(0xFF1E293B) : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // 2. Name & Model Specs
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        playerName,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isThinking) ...[
                      const SizedBox(width: 6),
                      _ThinkingPulseDot(color: theme.colorScheme.primary),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        providerName,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        modelId,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.65),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. Right Side: Captured Rack, Advantage & Last Move Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (capturedPieces.isNotEmpty)
                Wrap(
                  spacing: 1,
                  children: capturedPieces.take(6).map((p) {
                    return Text(
                      MaterialEval.pieceSymbols[p] ?? p,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                    );
                  }).toList(),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (lastMoveSan != null && lastMoveSan!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
                      ),
                      child: Text(
                        lastMoveDurationMs != null && lastMoveDurationMs! > 0
                            ? '$lastMoveSan (${lastMoveDurationMs}ms)'
                            : lastMoveSan!,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                  if (materialAdvantage != null && materialAdvantage! > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '+$materialAdvantage',
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF22C55E),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThinkingPulseDot extends StatefulWidget {
  final Color color;
  const _ThinkingPulseDot({required this.color});

  @override
  State<_ThinkingPulseDot> createState() => _ThinkingPulseDotState();
}

class _ThinkingPulseDotState extends State<_ThinkingPulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.2, end: 1.0).animate(_controller),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
