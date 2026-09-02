import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/sanitizer_utils.dart';
import '../../../../data/models/models.dart';
import '../../application/game_notifier.dart';
import 'move_history_list.dart';
import 'move_inspector_sheet.dart';

/// Compact draggable bottom sheet with tabs for live thought streaming, chat monologue, and move history.
class ThinkingBottomSheet extends ConsumerStatefulWidget {
  const ThinkingBottomSheet({super.key});

  @override
  ConsumerState<ThinkingBottomSheet> createState() => _ThinkingBottomSheetState();
}

class _ThinkingBottomSheetState extends ConsumerState<ThinkingBottomSheet>
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
    final liveThinking = ref.watch(gameNotifierProvider.select((s) => s.liveThinking));
    final isThinking = ref.watch(gameNotifierProvider.select((s) => s.gameState?.isThinking ?? false));
    final moves = ref.watch(gameNotifierProvider.select((s) => s.gameState?.moveHistory ?? <MoveData>[]));
    final thinkingPlayer = ref.watch(gameNotifierProvider.select((s) => s.gameState?.thinkingPlayer));
    final theme = Theme.of(context);

    if (isThinking) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    final sanitizedText = SanitizerUtils.sanitizeThoughtText(liveThinking);

    return DraggableScrollableSheet(
      initialChildSize: 0.14,
      minChildSize: 0.14,
      maxChildSize: 0.82,
      snap: true,
      snapSizes: const [0.14, 0.45, 0.82],
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.95),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border.all(
                color: isThinking
                    ? theme.colorScheme.primary.withOpacity(0.4)
                    : (theme.dividerTheme.color ?? Colors.transparent),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // 1. Drag Handle & Status Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
                  child: Column(
                    children: [
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isThinking
                              ? theme.colorScheme.primary
                              : Colors.grey.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            const SizedBox(width: 6),
                            Text(
                              '${thinkingPlayer == PlayerColor.white ? "White" : "Black"} AI Thinking...',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ] else ...[
                            const Icon(Icons.psychology_outlined, size: 13, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              'Reasoning & History (${moves.length} moves)',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // 2. Tab Bar Header
                TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: theme.colorScheme.primary,
                  labelColor: theme.colorScheme.primary,
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: const TextStyle(fontSize: 11),
                  tabs: [
                    Tab(
                      height: 28,
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
                    const Tab(height: 28, text: 'Monologue'),
                    Tab(height: 28, text: 'Moves (${moves.length})'),
                  ],
                ),

                // 3. Tab Bar Content Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Live Chain of Thought Stream
                      Container(
                        color: theme.colorScheme.surface,
                        child: sanitizedText.isEmpty
                            ? Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.psychology_alt_outlined,
                                        size: 28,
                                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isThinking
                                          ? 'Streaming live reasoning...'
                                          : 'Awaiting next turn...',
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface.withOpacity(0.45),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                controller: _streamScrollController,
                                padding: const EdgeInsets.all(14),
                                child: SelectableText(
                                  sanitizedText,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                      ),

                      // Tab 2: Full Monologue / Conversation Transcript
                      Container(
                        color: theme.colorScheme.surface,
                        child: moves.isEmpty
                            ? Center(
                                child: SingleChildScrollView(
                                  child: Text(
                                    'No thoughts logged yet.',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.all(10),
                                itemCount: moves.length,
                                itemBuilder: (context, index) {
                                  final move = moves[index];
                                  final isWhite = move.turn == PlayerColor.white;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isWhite
                                          ? theme.colorScheme.surfaceContainerLow
                                          : theme.colorScheme.surfaceContainerHigh,
                                      borderRadius: BorderRadius.circular(10),
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
                                                fontSize: 11.5,
                                              ),
                                            ),
                                            Text(
                                              '${move.durationMs}ms',
                                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 9.5),
                                            ),
                                          ],
                                        ),
                                        if (move.reasoning.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          SelectableText(
                                            SanitizerUtils.sanitizeThoughtText(move.reasoning),
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              fontFamily: 'monospace',
                                              fontSize: 11,
                                              height: 1.35,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),

                      // Tab 3: SAN Move History with Inspector
                      Container(
                        color: theme.colorScheme.surface,
                        child: moves.isEmpty
                            ? Center(
                                child: SingleChildScrollView(
                                  child: Text(
                                    'Match has not started.',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                                      fontSize: 11,
                                    ),
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
        );
      },
    );
  }
}
