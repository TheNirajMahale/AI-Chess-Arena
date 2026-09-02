import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/sanitizer_utils.dart';
import '../../../../data/models/models.dart';
import '../../application/game_notifier.dart';
import 'move_history_list.dart';
import 'move_inspector_sheet.dart';

/// Modal bottom sheet displaying real-time reasoning stream, monologue, and interactive move history.
class ReasoningSheet extends ConsumerStatefulWidget {
  const ReasoningSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReasoningSheet(),
    );
  }

  @override
  ConsumerState<ReasoningSheet> createState() => _ReasoningSheetState();
}

class _ReasoningSheetState extends ConsumerState<ReasoningSheet>
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
      initialChildSize: 0.65,
      minChildSize: 0.40,
      maxChildSize: 0.90,
      snap: true,
      snapSizes: const [0.40, 0.65, 0.90],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(
              color: isThinking
                  ? theme.colorScheme.primary.withOpacity(0.4)
                  : (theme.dividerTheme.color ?? Colors.transparent),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            children: [
              // 1. Drag Handle & Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isThinking
                            ? theme.colorScheme.primary
                            : Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.psychology_outlined,
                          color: isThinking ? theme.colorScheme.primary : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isThinking
                                ? '${thinkingPlayer == PlayerColor.white ? "White" : "Black"} AI Thinking...'
                                : 'Reasoning & Move History',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isThinking ? theme.colorScheme.primary : null,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          tooltip: 'Close',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Tab Bar
              TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: theme.colorScheme.primary,
                labelColor: theme.colorScheme.primary,
                labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Live Stream'),
                        if (isThinking) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Tab(text: 'Monologue'),
                  Tab(text: 'Moves (${moves.length})'),
                ],
              ),

              // 3. Tab Bar Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Live Chain of Thought Stream
                    Container(
                      color: theme.colorScheme.surface,
                      child: sanitizedText.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.psychology_alt_outlined,
                                    size: 40,
                                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isThinking
                                        ? 'Streaming live reasoning...'
                                        : 'Awaiting next turn...',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface.withOpacity(0.45),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              controller: _streamScrollController,
                              padding: const EdgeInsets.all(16),
                              child: SelectableText(
                                sanitizedText,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontFamily: 'monospace',
                                  fontSize: 12.5,
                                  height: 1.5,
                                ),
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
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.all(12),
                              itemCount: moves.length,
                              itemBuilder: (context, index) {
                                final move = moves[index];
                                final isWhite = move.turn == PlayerColor.white;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
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
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            '${move.durationMs}ms',
                                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      if (move.reasoning.isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        SelectableText(
                                          SanitizerUtils.sanitizeThoughtText(move.reasoning),
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontFamily: 'monospace',
                                            fontSize: 11.5,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    // Tab 3: Move History List
                    Container(
                      color: theme.colorScheme.surface,
                      child: moves.isEmpty
                          ? Center(
                              child: Text(
                                'Match has not started.',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                                  fontSize: 12,
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
        );
      },
    );
  }
}
