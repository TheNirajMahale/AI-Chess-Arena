import 'package:flutter_test/flutter_test.dart';
import 'package:chess_arena/data/models/models.dart';
import 'package:chess_arena/core/utils/fen_utils.dart';
import 'package:chess_arena/core/utils/material_eval.dart';

void main() {
  group('Model Serialization & Parsing Tests', () {
    test('PlayerConfig serializes and deserializes correctly', () {
      final config = PlayerConfig(
        name: 'Gemini Grandmaster',
        provider: ProviderType.gemini,
        modelId: 'gemini/gemini-2.5-flash',
        temperature: 0.8,
        thinkingMode: 'high',
        color: PlayerColor.white,
      );

      final json = config.toJson();
      expect(json['name'], 'Gemini Grandmaster');
      expect(json['provider'], 'gemini');
      expect(json['model_id'], 'gemini/gemini-2.5-flash');

      final fromJson = PlayerConfig.fromJson(json);
      expect(fromJson, config);
    });

    test('MoveData parses complete backend move frame', () {
      final json = {
        'move_number': 1,
        'turn': 'white',
        'san': 'e4',
        'uci': 'e2e4',
        'fen_before': 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
        'fen_after': 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
        'reasoning': 'Controlling the center with King Pawn opening.',
        'player_name': 'DeepSeek Engine',
        'model_id': 'deepseek/deepseek-chat',
        'duration_ms': 1200,
        'timestamp': '2026-09-01T12:00:00Z',
        'is_check': false,
        'is_checkmate': false,
        'is_capture': false,
        'captured_piece': null,
      };

      final move = MoveData.fromJson(json);
      expect(move.san, 'e4');
      expect(move.uci, 'e2e4');
      expect(move.turn, PlayerColor.white);
      expect(move.durationMs, 1200);
    });

    test('GameState parses and handles active turn data', () {
      final json = {
        'game_id': 'game_12345',
        'status': 'playing',
        'fen': 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
        'turn': 'black',
        'white_player': {
          'name': 'White Bot',
          'provider': 'openai',
          'model_id': 'gpt-4o',
          'temperature': 0.7,
        },
        'black_player': {
          'name': 'Black Bot',
          'provider': 'anthropic',
          'model_id': 'claude-3-5-sonnet',
          'temperature': 0.7,
        },
        'move_delay_seconds': 5,
        'current_move_number': 2,
        'move_history': [],
        'captured_by_white': ['p'],
        'captured_by_black': [],
        'pgn': '1. e4',
        'live_thinking': 'Analyzing c5 Sicilian...',
        'is_thinking': true,
        'thinking_player': 'black',
        'last_move_uci': 'e2e4',
      };

      final state = GameState.fromJson(json);
      expect(state.gameId, 'game_12345');
      expect(state.status, GameStatus.playing);
      expect(state.isThinking, true);
      expect(state.capturedByWhite, ['p']);
      expect(state.whitePlayer?.provider, ProviderType.openai);
    });

    test('SettingsPayload and ApiKeysConfig serialize and deserialize', () {
      const payload = SettingsPayload(
        keys: ApiKeysConfig(
          deepseekKey: 'sk-deepseek-123',
          openaiKey: 'sk-openai-456',
        ),
        defaultDelay: 15,
        includeAsciiBoard: true,
        historyContextLimit: 10,
        maxOutputTokens: 800,
      );

      final json = payload.toJson();
      expect(json['default_delay'], 15);
      expect(json['include_ascii_board'], true);

      final fromJson = SettingsPayload.fromJson(json);
      expect(fromJson.keys.deepseekKey, 'sk-deepseek-123');
      expect(fromJson.historyContextLimit, 10);
    });

    test('GameControlRequest and GameSummary serialize properly', () {
      const req = GameControlRequest(
        action: 'start',
        moveDelaySeconds: 8,
      );
      expect(req.toJson()['action'], 'start');

      const summary = GameSummary(
        gameId: 'match_99',
        whitePlayer: 'DeepSeek',
        blackPlayer: 'Gemini',
        movesCount: 30,
        result: GameResult(winner: PlayerColor.white, reason: 'checkmate'),
      );
      expect(summary.toJson()['game_id'], 'match_99');
      expect(summary.result?.winner, PlayerColor.white);
    });

    test('WsEvent sealed union parses all backend event types correctly', () {
      // 1. game_state
      final stateEvent = WsEvent.fromJson({
        'type': 'game_state',
        'state': {
          'game_id': 'ws_game_1',
          'status': 'idle',
          'fen': FenUtils.initialFen,
        }
      });
      expect(stateEvent, isA<WsEvent>());
      stateEvent.maybeWhen(
        gameState: (s) => expect(s.gameId, 'ws_game_1'),
        orElse: () => fail('Expected gameState'),
      );

      // 2. thinking_chunk
      final chunkEvent = WsEvent.fromJson({
        'type': 'thinking_chunk',
        'chunk': ' Nf3',
        'full_text': 'I will play Nf3',
        'player': 'white',
      });
      chunkEvent.maybeWhen(
        thinkingChunk: (chunk, full, player) {
          expect(chunk, ' Nf3');
          expect(full, 'I will play Nf3');
          expect(player, PlayerColor.white);
        },
        orElse: () => fail('Expected thinkingChunk'),
      );

      // 3. game_over
      final gameOverEvent = WsEvent.fromJson({
        'type': 'game_over',
        'result': {
          'winner': 'white',
          'reason': 'checkmate',
          'description': 'Checkmate! White wins.',
        }
      });
      gameOverEvent.maybeWhen(
        gameOver: (res) {
          expect(res.winner, PlayerColor.white);
          expect(res.reason, 'checkmate');
        },
        orElse: () => fail('Expected gameOver'),
      );

      // 4. pong
      final pongEvent = WsEvent.fromJson({'type': 'pong'});
      expect(pongEvent, const WsEvent.pong());
    });
  });

  group('Chess Utilities Tests', () {
    test('FenUtils translates coordinates and King positions', () {
      final board = FenUtils.parseBoard(FenUtils.initialFen);
      expect(board[0][4], 'k'); // e8
      expect(board[7][4], 'K'); // e1

      final whiteKing = FenUtils.findKingSquare(FenUtils.initialFen, PlayerColor.white);
      final blackKing = FenUtils.findKingSquare(FenUtils.initialFen, PlayerColor.black);
      expect(whiteKing, 'e1');
      expect(blackKing, 'e8');

      final e4Indices = FenUtils.squareToIndex('e4');
      expect(e4Indices?.row, 4);
      expect(e4Indices?.col, 4);
      expect(FenUtils.indexToSquare(4, 4), 'e4');
    });

    test('MaterialEval calculates correct piece scores and diffs', () {
      final whiteCaptured = ['p', 'p', 'n']; // 1 + 1 + 3 = 5
      final blackCaptured = ['P', 'Q']; // 1 + 9 = 10

      final whiteScore = MaterialEval.calculateScore(whiteCaptured);
      final blackScore = MaterialEval.calculateScore(blackCaptured);
      expect(whiteScore, 5);
      expect(blackScore, 10);

      final advantage = MaterialEval.calculateAdvantage(
        capturedByWhite: whiteCaptured,
        capturedByBlack: blackCaptured,
      );
      expect(advantage, -5); // Black is ahead by 5 material
    });
  });
}
