import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../core/utils/fen_utils.dart';
import '../../../../core/utils/material_eval.dart';
import '../../../../data/models/models.dart';
import '../../application/game_notifier.dart';
import '../../../setup/application/match_setup_provider.dart';
import '../../../shared_widgets/chess_board_view.dart';
import '../../../shared_widgets/eval_bar.dart';
import '../../../shared_widgets/player_hud_card.dart';
import '../../../shared_widgets/theme_picker_sheet.dart';
import '../widgets/countdown_ring.dart';
import '../widgets/inline_reasoning_console.dart';
import '../widgets/victory_overlay.dart';

/// Center stage Live Arena screen with responsive layouts for Mobile, Tablet, and Desktop:
/// - Collapsed Mode: Balanced spacing between HUDs & Board with bottom dock + embedded play button.
/// - Expanded Mode: Simultaneous split console + WhatsApp-style circular action FAB with zero overflow.
/// - Wide Desktop Mode: Side-by-side board stage and reasoning console.
class ArenaScreen extends ConsumerStatefulWidget {
  final VoidCallback onOpenSetup;

  const ArenaScreen({
    super.key,
    required this.onOpenSetup,
  });

  @override
  ConsumerState<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends ConsumerState<ArenaScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  bool _isConsoleExpanded = false;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleConsoleExpand() {
    setState(() {
      _isConsoleExpanded = !_isConsoleExpanded;
      if (_isConsoleExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(gameNotifierProvider.notifier);

    // Fine-grained Riverpod selectors for minimal rebuilds
    final isConnected = ref.watch(gameNotifierProvider.select((s) => s.isConnected));
    final isFlipped = ref.watch(gameNotifierProvider.select((s) => s.isBoardFlipped));
    final isThinking = ref.watch(gameNotifierProvider.select((s) => s.gameState?.isThinking ?? false));
    final activeTurn = ref.watch(gameNotifierProvider.select((s) => s.gameState?.turn ?? PlayerColor.white));
    final fen = ref.watch(gameNotifierProvider.select((s) => s.gameState?.fen ?? FenUtils.initialFen));
    final lastMoveUci = ref.watch(gameNotifierProvider.select((s) => s.gameState?.lastMoveUci));
    final result = ref.watch(gameNotifierProvider.select((s) => s.gameState?.result));
    final status = ref.watch(gameNotifierProvider.select((s) => s.gameState?.status ?? GameStatus.idle));
    final isActionInProgress = ref.watch(gameNotifierProvider.select((s) => s.isActionInProgress));

    final setupWhite = ref.watch(matchSetupProvider.select((s) => s.whitePlayer));
    final setupBlack = ref.watch(matchSetupProvider.select((s) => s.blackPlayer));
    final whitePlayer = ref.watch(gameNotifierProvider.select((s) => s.gameState?.whitePlayer)) ?? setupWhite;
    final blackPlayer = ref.watch(gameNotifierProvider.select((s) => s.gameState?.blackPlayer)) ?? setupBlack;
    final countdownSeconds = ref.watch(gameNotifierProvider.select((s) => s.gameState?.countdownSeconds));
    final moveDelaySeconds = ref.watch(gameNotifierProvider.select((s) => s.gameState?.moveDelaySeconds ?? 10));

    final moves = ref.watch(gameNotifierProvider.select((s) => s.gameState?.moveHistory ?? <MoveData>[]));
    final lastWhiteMove = moves.where((m) => m.turn == PlayerColor.white).lastOrNull;
    final lastBlackMove = moves.where((m) => m.turn == PlayerColor.black).lastOrNull;

    final capturedByWhite = ref.watch(gameNotifierProvider.select((s) => s.gameState?.capturedByWhite ?? []));
    final capturedByBlack = ref.watch(gameNotifierProvider.select((s) => s.gameState?.capturedByBlack ?? []));
    final whiteAdvantage = MaterialEval.calculateAdvantage(
      capturedByWhite: capturedByWhite,
      capturedByBlack: capturedByBlack,
    );
    final blackAdvantage = -whiteAdvantage;

    final boardTheme = ref.watch(appSettingsProvider.select((s) => s.boardTheme));

    // Listen to error messages and show clear, actionable floating SnackBar
    ref.listen<String?>(
      gameNotifierProvider.select((s) => s.errorMessage),
      (prev, next) {
        if (next != null && next.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(next, style: const TextStyle(fontSize: 12.5))),
                ],
              ),
              backgroundColor: const Color(0xFFDC2626),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () => notifier.clearError(),
              ),
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 9,
              height: 9,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isConnected ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                boxShadow: [
                  BoxShadow(
                    color: (isConnected ? const Color(0xFF10B981) : const Color(0xFFEF4444))
                        .withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const Text('AI Chess Arena'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_vert_rounded),
            tooltip: 'Flip Perspective',
            onPressed: () => notifier.toggleBoardFlip(),
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Themes',
            onPressed: () => ThemePickerSheet.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Match Setup',
            onPressed: widget.onOpenSetup,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideDesktop = constraints.maxWidth > 750;

          // =========================================================
          // A. WIDE DESKTOP TWO-COLUMN LAYOUT
          // =========================================================
          if (isWideDesktop) {
            final maxBoardDim = math.min(
              constraints.maxWidth * 0.48 - 50,
              constraints.maxHeight - 160,
            );

            return Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left Column: Player HUDs + Chessboard
                        SizedBox(
                          width: maxBoardDim + 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PlayerHudCard(
                                config: isFlipped ? whitePlayer : blackPlayer,
                                color: isFlipped ? PlayerColor.white : PlayerColor.black,
                                isThinking: isThinking &&
                                    (isFlipped
                                        ? activeTurn == PlayerColor.white
                                        : activeTurn == PlayerColor.black),
                                materialAdvantage: isFlipped ? whiteAdvantage : blackAdvantage,
                                lastMoveSan: isFlipped ? lastWhiteMove?.san : lastBlackMove?.san,
                                lastMoveDurationMs: isFlipped
                                    ? lastWhiteMove?.durationMs
                                    : lastBlackMove?.durationMs,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RepaintBoundary(
                                    child: EvalBar(
                                      materialAdvantage: whiteAdvantage,
                                      isFlipped: isFlipped,
                                      height: maxBoardDim,
                                      width: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  RepaintBoundary(
                                    child: ChessBoardView(
                                      fen: fen,
                                      theme: boardTheme,
                                      lastMoveUci: lastMoveUci,
                                      isCheck: false,
                                      activeTurn: activeTurn,
                                      isFlipped: isFlipped,
                                      size: maxBoardDim,
                                    ),
                                  ),
                                ],
                              ),
                              PlayerHudCard(
                                config: isFlipped ? blackPlayer : whitePlayer,
                                color: isFlipped ? PlayerColor.black : PlayerColor.white,
                                isThinking: isThinking &&
                                    (isFlipped
                                        ? activeTurn == PlayerColor.black
                                        : activeTurn == PlayerColor.white),
                                materialAdvantage: isFlipped ? blackAdvantage : whiteAdvantage,
                                lastMoveSan: isFlipped ? lastBlackMove?.san : lastWhiteMove?.san,
                                lastMoveDurationMs: isFlipped
                                    ? lastBlackMove?.durationMs
                                    : lastWhiteMove?.durationMs,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Right Column: Full Expanded Reasoning Console
                        Expanded(
                          child: InlineReasoningConsole(
                            expandProgress: 1.0,
                            isExpanded: true,
                            onToggleExpand: () {},
                            onStart: () => notifier.startMatch(),
                            onPause: () => notifier.pauseMatch(),
                            onResume: () => notifier.resumeMatch(),
                            onStep: () => notifier.stepMatch(),
                            onStop: () => notifier.stopMatch(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (result != null)
                  VictoryOverlay(
                    result: result,
                    whitePlayerName: whitePlayer.name,
                    blackPlayerName: blackPlayer.name,
                    onNewMatch: widget.onOpenSetup,
                  ),
              ],
            );
          }

          // =========================================================
          // B. PORTRAIT / COMPACT LAYOUT (Zero-Overflow Constraint Math)
          // =========================================================
          final availableHeight = constraints.maxHeight - 16;
          final maxBoardWidth = constraints.maxWidth - 54;

          final collapsedBoardSize = (availableHeight - 210).clamp(200.0, maxBoardWidth);
          final expandedBoardSize = (availableHeight * 0.38).clamp(160.0, maxBoardWidth);

          final dynamicCollapsedGap = math.max(
            4.0,
            (availableHeight - (collapsedBoardSize + 130 + 64.0)) / 3.2,
          );

          return AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              final t = _expandAnimation.value;
              final currentBoardSize = lerpDouble(collapsedBoardSize, expandedBoardSize, t)!;
              final currentGap = lerpDouble(dynamicCollapsedGap, 5.0, t)!;

              // Exact budget matching: guarantees total vertical height equals availableHeight with 0.0px overflow!
              final currentConsoleHeight = lerpDouble(
                64.0,
                math.max(140.0, availableHeight - (currentBoardSize + 130 + (3 * currentGap))),
                t,
              )!;

              return Stack(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 4, 14, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Top Player HUD
                          PlayerHudCard(
                            config: isFlipped ? whitePlayer : blackPlayer,
                            color: isFlipped ? PlayerColor.white : PlayerColor.black,
                            isThinking: isThinking &&
                                (isFlipped
                                    ? activeTurn == PlayerColor.white
                                    : activeTurn == PlayerColor.black),
                            materialAdvantage: isFlipped ? whiteAdvantage : blackAdvantage,
                            lastMoveSan: isFlipped ? lastWhiteMove?.san : lastBlackMove?.san,
                            lastMoveDurationMs: isFlipped
                                ? lastWhiteMove?.durationMs
                                : lastBlackMove?.durationMs,
                          ),
                          SizedBox(height: currentGap),

                          // 2. Center Stage: Eval Bar & Board with Repaint Boundary
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RepaintBoundary(
                                  child: EvalBar(
                                    materialAdvantage: whiteAdvantage,
                                    isFlipped: isFlipped,
                                    height: currentBoardSize,
                                    width: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                RepaintBoundary(
                                  child: ChessBoardView(
                                    fen: fen,
                                    theme: boardTheme,
                                    lastMoveUci: lastMoveUci,
                                    isCheck: false,
                                    activeTurn: activeTurn,
                                    isFlipped: isFlipped,
                                    size: currentBoardSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: currentGap),

                          // 3. Bottom Player HUD
                          PlayerHudCard(
                            config: isFlipped ? blackPlayer : whitePlayer,
                            color: isFlipped ? PlayerColor.black : PlayerColor.white,
                            isThinking: isThinking &&
                                (isFlipped
                                    ? activeTurn == PlayerColor.black
                                    : activeTurn == PlayerColor.white),
                            materialAdvantage: isFlipped ? blackAdvantage : whiteAdvantage,
                            lastMoveSan: isFlipped ? lastBlackMove?.san : lastWhiteMove?.san,
                            lastMoveDurationMs: isFlipped
                                ? lastBlackMove?.durationMs
                                : lastWhiteMove?.durationMs,
                          ),

                          // Delay countdown indicator (if active)
                          if (countdownSeconds != null && countdownSeconds > 0) ...[
                            const SizedBox(height: 2),
                            Center(
                              child: CountdownRing(
                                totalDelaySeconds: moveDelaySeconds,
                                remainingSeconds: countdownSeconds,
                              ),
                            ),
                          ],
                          SizedBox(height: currentGap),

                          // 4. Fluid Animated Reasoning Console (100% matched height, zero overflow)
                          SizedBox(
                            height: currentConsoleHeight,
                            child: InlineReasoningConsole(
                              expandProgress: t,
                              isExpanded: _isConsoleExpanded,
                              onToggleExpand: _toggleConsoleExpand,
                              onStart: () => notifier.startMatch(),
                              onPause: () => notifier.pauseMatch(),
                              onResume: () => notifier.resumeMatch(),
                              onStep: () => notifier.stepMatch(),
                              onStop: () => notifier.stopMatch(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 5. Victory Overlay
                  if (result != null)
                    VictoryOverlay(
                      result: result,
                      whitePlayerName: whitePlayer.name,
                      blackPlayerName: blackPlayer.name,
                      onNewMatch: widget.onOpenSetup,
                    ),
                ],
              );
            },
          );
        },
      ),
      // WhatsApp-Style Floating Action Button
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AnimatedBuilder(
        animation: _expandAnimation,
        builder: (context, _) {
          final t = _expandAnimation.value;
          final isWideDesktop = MediaQuery.of(context).size.width > 750;

          if (!isWideDesktop && t <= 0.02) return const SizedBox.shrink();

          return Transform.scale(
            scale: isWideDesktop ? 1.0 : t,
            child: Opacity(
              opacity: isWideDesktop ? 1.0 : t.clamp(0.0, 1.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8, right: 4),
                child: _WhatsAppStyleFab(
                  status: status,
                  isActionInProgress: isActionInProgress,
                  onStart: () => notifier.startMatch(),
                  onPause: () => notifier.pauseMatch(),
                  onResume: () => notifier.resumeMatch(),
                  onStep: () => notifier.stepMatch(),
                  onStop: () => notifier.stopMatch(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Circular, icon-only WhatsApp-style floating action buttons with high-contrast elevated styling.
class _WhatsAppStyleFab extends StatelessWidget {
  final GameStatus status;
  final bool isActionInProgress;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStep;
  final VoidCallback onStop;

  const _WhatsAppStyleFab({
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
      return FloatingActionButton(
        heroTag: 'fab_wa_loading',
        onPressed: null,
        elevation: 6,
        shape: const CircleBorder(),
        backgroundColor: theme.colorScheme.primary,
        child: const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
        ),
      );
    }

    switch (status) {
      case GameStatus.idle:
      case GameStatus.finished:
        return FloatingActionButton(
          heroTag: 'fab_wa_start',
          onPressed: onStart,
          elevation: 6,
          shape: const CircleBorder(),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          tooltip: 'Start Match',
          child: const Icon(Icons.play_arrow_rounded, size: 30),
        );

      case GameStatus.playing:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.small(
              heroTag: 'fab_wa_stop',
              onPressed: onStop,
              shape: const CircleBorder(),
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              tooltip: 'Stop Match',
              child: const Icon(Icons.stop_rounded, size: 20),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'fab_wa_pause',
              onPressed: onPause,
              elevation: 6,
              shape: const CircleBorder(),
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
              tooltip: 'Pause',
              child: const Icon(Icons.pause_rounded, size: 28),
            ),
          ],
        );

      case GameStatus.paused:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.small(
                  heroTag: 'fab_wa_stop_p',
                  onPressed: onStop,
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  tooltip: 'Reset Match',
                  child: const Icon(Icons.stop_rounded, size: 18),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  heroTag: 'fab_wa_step',
                  onPressed: onStep,
                  shape: const CircleBorder(),
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  tooltip: 'Step Turn',
                  child: const Icon(Icons.skip_next_rounded, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'fab_wa_resume',
              onPressed: onResume,
              elevation: 6,
              shape: const CircleBorder(),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              tooltip: 'Resume Match',
              child: const Icon(Icons.play_arrow_rounded, size: 28),
            ),
          ],
        );
    }
  }
}
