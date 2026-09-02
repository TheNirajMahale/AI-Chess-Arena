---
name: flutter-testing
description: >-
  Comprehensive guide for Flutter testing, including Unit Testing of notifiers and repositories,
  Widget Testing with tester.pumpWidget, Mocktail mocking patterns, and static analysis verification.
---

# Flutter Testing & Verification Skill

This skill provides guidelines and patterns for testing Flutter applications to ensure high reliability and zero regressions.

---

## 1. Unit Testing: State Notifiers & Repositories

Using `mocktail` for dependency isolation:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:llm_chess/data/repositories/game_repository_impl.dart';
import 'package:llm_chess/domain/entities/player_config.dart';

class MockGameRemoteDataSource extends Mock implements GameRemoteDataSource {}

void main() {
  late MockGameRemoteDataSource mockDataSource;
  late GameRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockGameRemoteDataSource();
    repository = GameRepositoryImpl(dataSource: mockDataSource);
  });

  test('controlGame sends start action correctly to remote data source', () async {
    const whitePlayer = PlayerConfig(
      name: 'Gemini 2.5 Flash',
      provider: 'gemini',
      modelId: 'gemini/gemini-2.5-flash',
    );
    const blackPlayer = PlayerConfig(
      name: 'DeepSeek Chat',
      provider: 'deepseek',
      modelId: 'deepseek/deepseek-chat',
    );

    when(() => mockDataSource.controlGame(
          action: 'start',
          whitePlayer: any(named: 'whitePlayer'),
          blackPlayer: any(named: 'blackPlayer'),
          moveDelaySeconds: any(named: 'moveDelaySeconds'),
        )).thenAnswer((_) async => {'status': 'ok'});

    final result = await repository.controlGame(
      action: 'start',
      whitePlayer: whitePlayer,
      blackPlayer: blackPlayer,
      moveDelaySeconds: 10,
    );

    expect(result['status'], 'ok');
    verify(() => mockDataSource.controlGame(
          action: 'start',
          whitePlayer: any(named: 'whitePlayer'),
          blackPlayer: any(named: 'blackPlayer'),
          moveDelaySeconds: 10,
        )).called(1);
  });
}
```

---

## 2. Widget Testing with Riverpod

Using `ProviderScope` overrides in widget tests:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:llm_chess/presentation/widgets/chessboard/eval_bar.dart';

void main() {
  testWidgets('EvalBar renders balanced at 50% for materialDiff = 0', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EvalBar(materialDiff: 0),
        ),
      ),
    );

    expect(find.byType(EvalBar), findsOneWidget);
  });
}
```

---

## 3. Pre-Flight Verification Checklist
Always run:
1. `flutter analyze` — Must report **No issues found!** (0 warnings, 0 lints).
2. `flutter test` — Must pass 100% of test suites with 0 failures.
3. `dart format --output=none --set-exit-if-changed .` — Ensures all code matches official Dart formatting standards.
