import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/sanitizer_utils.dart';
import '../../../../data/models/models.dart';
import '../../application/game_notifier.dart';
import 'move_history_list.dart';
import 'move_inspector_sheet.dart';

/// Interactive reasoning console with butter-smooth animation between compact dock and expanded 3-tab inspector.
class InlineReasoningConsole extends ConsumerStatefulWidget {
  final double expandProgress; // 0.0 = Collapsed, 1.0 = Fully Expanded
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStep;
  final VoidCallback onStop;

  const InlineReasoningConsole({
    super.key,
    required this.expandProgress,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onStep,
    required this.onStop,
  });

  @override
  ConsumerState<InlineReasoningConsole> createState() => _InlineReasoningConsoleState();
}

class _InlineReasoningConsoleState extends ConsumerState<InlineReasoningConsole>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _streamScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _streamScrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_streamScrollController.hasClients) {
      _streamScrollController.animateTo(
        _streamScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.expandProgress;
    final theme = Theme.of(context);

    // Fine-grained Riverpod selectors to avoid whole-tree rebuilds
    final isThinking = ref.watch(gameNotifierProvider.select((s) => s.gameState?.isThinking ?? false));
    final thinkingPlayer = ref.watch(gameNotifierProvider.select((s) => s.gameState?.thinkingPlayer));
    final countdownSeconds = ref.watch(gameNotifierProvider.select((s) => s.gameState?.countdownSeconds));
    final moves = ref.watch(gameNotifierProvider.select((s) => s.gameState?.moveHistory ?? <MoveData>[]));
    final status = ref.watch(gameNotifierProvider.select((s) => s.gameState?.status ?? GameStatus.idle));
    final isActionInProgress = ref.watch(gameNotifierProvider.select((s) => s.isActionInProgress));

    final lastMove = moves.isNotEmpty ? moves.last : null;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        final delta = details.primaryDelta ?? 0;
        if (!widget.isExpanded && delta < -5) {
          widget.onToggleExpand();
        } else if (widget.isExpanded && delta > 5) {
          widget.onToggleExpand();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isThinking
                ? theme.colorScheme.primary.withOpacity(0.55)
                : (theme.dividerTheme.color ?? Colors.transparent),
            width: isThinking ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18 * (0.8 + 0.4 * t)),
              blurRadius: 10 + 4 * t,
              offset: Offset(0, 3 + 2 * t),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // =========================================================
            // LAYER A: EXPANDED VIEW (Tabs + Content)
            // =========================================================
            Opacity(
              opacity: (t - 0.25).clamp(0.0, 0.75) / 0.75,
              child: IgnorePointer(
                ignoring: t < 0.5,
                child: Column(
                  children: [
                    // Top Tab Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                        border: Border(
                          bottom: BorderSide(
                            color: theme.dividerTheme.color ?? Colors.transparent,
                            width: 0.8,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TabBar(
                              controller: _tabController,
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor: theme.colorScheme.primary,
                              labelColor: theme.colorScheme.primary,
                              labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                              unselectedLabelStyle: const TextStyle(fontSize: 11.5),
                              padding: EdgeInsets.zero,
                              labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                              tabs: [
                                Tab(
                                  height: 32,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Live Stream'),
                                      if (isThinking) ...[
                                        const SizedBox(width: 4),
                                        Container(
                                          width: 5,
                                          height: 5,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF10B981),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const Tab(height: 32, text: 'Monologue'),
                                Tab(height: 32, text: 'Moves'),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 22),
                            tooltip: 'Minimize Console',
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            onPressed: widget.onToggleExpand,
                          ),
                        ],
                      ),
                    ),

                    // Tab Views
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Tab 1: Live Stream (Isolated Consumer for high frequency tokens)
                          RepaintBoundary(
                            child: Container(
                              color: theme.colorScheme.surface,
                              child: Consumer(
                                builder: (context, ref, _) {
                                  final liveThinking = ref.watch(gameNotifierProvider.select((s) => s.liveThinking));
                                  final isThinkingNow = ref.watch(gameNotifierProvider.select((s) => s.gameState?.isThinking ?? false));
                                  final sanitized = SanitizerUtils.sanitizeThoughtText(liveThinking);

                                  if (isThinkingNow) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                                  }

                                  if (sanitized.isEmpty) {
                                    return Center(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.psychology_alt_outlined,
                                                size: 24,
                                                color: theme.colorScheme.onSurface.withOpacity(0.3),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                isThinkingNow
                                                    ? '${thinkingPlayer == PlayerColor.white ? "White" : "Black"} AI thinking...'
                                                    : 'Awaiting next turn...',
                                                style: TextStyle(
                                                  color: theme.colorScheme.onSurface.withOpacity(0.45),
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return SingleChildScrollView(
                                    controller: _streamScrollController,
                                    padding: const EdgeInsets.all(10),
                                    child: SelectableText(
                                      sanitized,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontFamily: 'monospace',
                                        fontSize: 11.5,
                                        height: 1.35,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Tab 2: Monologue Logs
                          Container(
                            color: theme.colorScheme.surface,
                            child: moves.isEmpty
                                ? Center(
                                    child: Text(
                                      'No thoughts logged yet.',
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                                        fontSize: 11,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: moves.length,
                                    itemBuilder: (context, index) {
                                      final move = moves[index];
                                      final isWhite = move.turn == PlayerColor.white;
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 6),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: isWhite
                                              ? theme.colorScheme.surfaceContainerLow
                                              : theme.colorScheme.surfaceContainerHigh,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: theme.dividerTheme.color ?? Colors.transparent,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '${move.moveNumber}. ${move.san} • ${move.playerName}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                Text(
                                                  '${move.durationMs}ms',
                                                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 9),
                                                ),
                                              ],
                                            ),
                                            if (move.reasoning.isNotEmpty) ...[
                                              const SizedBox(height: 3),
                                              SelectableText(
                                                SanitizerUtils.sanitizeThoughtText(move.reasoning),
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  fontFamily: 'monospace',
                                                  fontSize: 10.5,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),

                          // Tab 3: Moves
                          Container(
                            color: theme.colorScheme.surface,
                            child: moves.isEmpty
                                ? Center(
                                    child: Text(
                                      'Match has not started.',
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                                        fontSize: 11,
                                      ),
                                    ),
                                  )
                                : MoveHistoryList(
                                    moves: moves,
                                    onSelectMove: (move) => MoveInspectorSheet.show(context, move),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =========================================================
            // LAYER B: COLLAPSED VIEW (64dp Preview Dock + Embedded Control)
            // =========================================================
            if (t < 0.9)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 64,
                child: Opacity(
                  opacity: (1.0 - t * 2.0).clamp(0.0, 1.0),
                  child: IgnorePointer(
                    ignoring: t > 0.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        children: [
                          // Left/Center Tappable Preview
                          Expanded(
                            child: InkWell(
                              onTap: widget.onToggleExpand,
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Top status row
                                    Row(
                                      children: [
                                        if (isThinking) ...[
                                          SizedBox(
                                            width: 9,
                                            height: 9,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '${thinkingPlayer == PlayerColor.white ? "White" : "Black"} AI Thinking',
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ] else if (countdownSeconds != null && countdownSeconds > 0) ...[
                                          Icon(Icons.hourglass_top_rounded, size: 12, color: Colors.amber[700]),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Delay: ${countdownSeconds}s',
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber[700],
                                            ),
                                          ),
                                        ] else ...[
                                          const Icon(Icons.psychology_outlined, size: 13, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Reasoning & Moves (${moves.length})',
                                            style: theme.textTheme.labelSmall?.copyWith(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.surfaceContainerLow,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Expand',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 2),
                                              Icon(
                                                Icons.keyboard_arrow_up_rounded,
                                                size: 13,
                                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),

                                    // Dynamic preview text
                                    Consumer(
                                      builder: (context, ref, _) {
                                        final liveThinking = ref.watch(gameNotifierProvider.select((s) => s.liveThinking));
                                        final isThinkingNow = ref.watch(gameNotifierProvider.select((s) => s.gameState?.isThinking ?? false));
                                        final cleanSnippet = SanitizerUtils.sanitizeThoughtText(liveThinking)
                                            .replaceAll('\n', ' ')
                                            .trim();

                                        return Text(
                                          isThinkingNow
                                              ? (cleanSnippet.isNotEmpty ? cleanSnippet : 'Generating move...')
                                              : (lastMove != null
                                                  ? 'Last: ${lastMove.moveNumber}. ${lastMove.san} (${lastMove.durationMs}ms)'
                                                  : 'Tap or drag up to expand thoughts & moves'),
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            color: isThinkingNow
                                                ? theme.colorScheme.onSurface
                                                : theme.colorScheme.onSurface.withOpacity(0.7),
                                            fontStyle: isThinkingNow ? FontStyle.italic : FontStyle.normal,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Divider
                          Container(
                            height: 32,
                            width: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: theme.dividerTheme.color ?? Colors.grey.withOpacity(0.2),
                          ),

                          // Embedded Controls in Collapsed Mode
                          _CollapsedActionControls(
                            status: status,
                            isActionInProgress: isActionInProgress,
                            onStart: widget.onStart,
                            onPause: widget.onPause,
                            onResume: widget.onResume,
                            onStep: widget.onStep,
                            onStop: widget.onStop,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Circular action button controls embedded into the collapsed bottom dock.
class _CollapsedActionControls extends StatelessWidget {
  final GameStatus status;
  final bool isActionInProgress;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStep;
  final VoidCallback onStop;

  const _CollapsedActionControls({
    required this.status,
    required this.isActionInProgress,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onStep,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isActionInProgress) {
      return Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    switch (status) {
      case GameStatus.idle:
      case GameStatus.finished:
        return _CircleActionButton(
          size: 36,
          icon: Icons.play_arrow_rounded,
          iconSize: 22,
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          tooltip: 'Start Match',
          onPressed: onStart,
        );

      case GameStatus.playing:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircleActionButton(
              size: 30,
              icon: Icons.stop_rounded,
              iconSize: 16,
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              tooltip: 'Stop Match',
              onPressed: onStop,
            ),
            const SizedBox(width: 5),
            _CircleActionButton(
              size: 36,
              icon: Icons.pause_rounded,
              iconSize: 20,
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
              tooltip: 'Pause',
              onPressed: onPause,
            ),
          ],
        );

      case GameStatus.paused:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircleActionButton(
              size: 28,
              icon: Icons.stop_rounded,
              iconSize: 14,
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              tooltip: 'Reset Match',
              onPressed: onStop,
            ),
            const SizedBox(width: 4),
            _CircleActionButton(
              size: 28,
              icon: Icons.skip_next_rounded,
              iconSize: 14,
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.onPrimaryContainer,
              tooltip: 'Step Turn',
              onPressed: onStep,
            ),
            const SizedBox(width: 4),
            _CircleActionButton(
              size: 36,
              icon: Icons.play_arrow_rounded,
              iconSize: 20,
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              tooltip: 'Resume',
              onPressed: onResume,
            ),
          ],
        );
    }
  }
}

class _CircleActionButton extends StatelessWidget {
  final double size;
  final IconData icon;
  final double iconSize;
  final Color backgroundColor;
  final Color foregroundColor;
  final String tooltip;
  final VoidCallback onPressed;

  const _CircleActionButton({
    required this.size,
    required this.icon,
    required this.iconSize,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: backgroundColor,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Tooltip(
            message: tooltip,
            child: Icon(
              icon,
              size: iconSize,
              color: foregroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
