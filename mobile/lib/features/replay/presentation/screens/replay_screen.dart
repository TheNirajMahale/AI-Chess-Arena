import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../data/models/models.dart';
import '../../../shared_widgets/chess_board_view.dart';
import '../../../shared_widgets/eval_bar.dart';
import '../../../shared_widgets/player_hud_card.dart';
import '../../../shared_widgets/theme_picker_sheet.dart';
import '../../application/replay_controller_provider.dart';
import '../widgets/historical_spec_card.dart';
import '../widgets/ply_scrubber.dart';
import '../widgets/replay_controls.dart';

/// Replay Inspector screen for stepping through and analyzing past matches move-by-move.
class ReplayScreen extends ConsumerStatefulWidget {
  final String gameId;

  const ReplayScreen({
    super.key,
    required this.gameId,
  });

  @override
  ConsumerState<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends ConsumerState<ReplayScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(replayControllerProvider.notifier).loadGame(widget.gameId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final replayState = ref.watch(replayControllerProvider);
    final replayNotifier = ref.read(replayControllerProvider.notifier);
    final boardTheme = ref.watch(appSettingsProvider.select((s) => s.boardTheme));
    final theme = Theme.of(context);

    if (replayState.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Replay Inspector')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (replayState.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Replay Inspector')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 40, color: Colors.red),
                const SizedBox(height: 10),
                Text(replayState.errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => replayNotifier.loadGame(widget.gameId),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final game = replayState.fullGame;
    if (game == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final isFlipped = replayState.isBoardFlipped;
    final currentMove = replayState.currentMove;
    final fen = replayState.currentFen;
    final lastMoveUci = replayState.lastMoveUci;
    final advantage = replayState.materialAdvantage;

    final whitePlayer = game.whitePlayer;
    final blackPlayer = game.blackPlayer;

    final mediaQuery = MediaQuery.of(context);
    final availableWidth = mediaQuery.size.width - 32;
    final boardSize = (availableWidth - 30).clamp(240.0, 420.0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Replay • ${game.gameId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_vert_rounded),
            tooltip: 'Flip Board',
            onPressed: () => replayNotifier.toggleBoardFlip(),
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Themes',
            onPressed: () => ThemePickerSheet.show(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. Top Player HUD
            PlayerHudCard(
              config: isFlipped ? whitePlayer : blackPlayer,
              color: isFlipped ? PlayerColor.white : PlayerColor.black,
              isTurn: currentMove?.turn == (isFlipped ? PlayerColor.black : PlayerColor.white),
              materialAdvantage: isFlipped ? advantage : -advantage,
            ),
            const SizedBox(height: 10),

            // 2. Chessboard & Eval Bar Center Stage
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EvalBar(
                  materialAdvantage: advantage,
                  isFlipped: isFlipped,
                  height: boardSize,
                  width: 14,
                ),
                const SizedBox(width: 10),
                ChessBoardView(
                  fen: fen,
                  theme: boardTheme,
                  lastMoveUci: lastMoveUci,
                  isCheck: currentMove?.isCheck ?? false,
                  activeTurn: currentMove?.turn.opponent ?? PlayerColor.white,
                  isFlipped: isFlipped,
                  size: boardSize,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 3. Bottom Player HUD
            PlayerHudCard(
              config: isFlipped ? blackPlayer : whitePlayer,
              color: isFlipped ? PlayerColor.black : PlayerColor.white,
              isTurn: currentMove?.turn == (isFlipped ? PlayerColor.white : PlayerColor.black),
              materialAdvantage: isFlipped ? -advantage : advantage,
            ),
            const SizedBox(height: 14),

            // 4. Ply Scrubber
            PlyScrubber(
              currentPly: replayState.currentPly,
              totalPlies: replayState.totalPlies,
              onPlyChanged: (ply) => replayNotifier.setPly(ply),
              onFirst: () => replayNotifier.firstPly(),
              onPrev: () => replayNotifier.prevPly(),
              onNext: () => replayNotifier.nextPly(),
              onLast: () => replayNotifier.lastPly(),
            ),
            const SizedBox(height: 10),

            // 5. Replay Autoplay & Pace Controls
            ReplayControls(
              isAutoPlaying: replayState.isAutoPlaying,
              paceSeconds: replayState.paceSeconds,
              pgn: game.pgn,
              onToggleAutoPlay: () => replayNotifier.toggleAutoPlay(),
              onPaceChanged: (val) => replayNotifier.setPace(val),
            ),
            const SizedBox(height: 10),

            // 6. Current Move Reasoning Card
            if (currentMove != null && currentMove.reasoning.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${currentMove.moveNumber}. ${currentMove.san} (${currentMove.playerName})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          '${currentMove.durationMs} ms',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SelectableText(
                      currentMove.reasoning,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

            // 7. Historical Specifications Collapsible Card
            HistoricalSpecCard(game: game),
          ],
        ),
      ),
    );
  }
}
