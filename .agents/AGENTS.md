# Flutter & Dart Engineering Directives

## 1. Architectural Discipline & Separation of Concerns (Clean Architecture)
- **Strict Layer Isolation**: Maintain rigid boundaries between application layers:
  - **Data / Network Layer**: Data sources (REST clients using Dio, WebSocket channels), DTOs, JSON serialization, and raw error interceptors. No UI or business logic.
  - **Domain / Models Layer**: Pure Dart entity models, value objects, immutable domain state, and repository interfaces. Framework-agnostic and free of Flutter UI imports.
  - **Application / State Layer**: State management notifiers/controllers (Riverpod / BLoC / Cubit), use cases, and business workflows. Orchestrates data flow without direct widget coupling.
  - **Presentation Layer**: Flutter widgets, view models, design system components, themes, and screen layouts. Never make direct network or database calls inside widget build methods.
- **Single Responsibility Principle (SRP)**: Every widget, controller, repository, and service must have one well-defined reason to change. Avoid massive "god widgets" that mix UI layout, state mutations, and API calls.

---

## 2. Flutter Widget & UI Performance Standards
- **Constant Constructors (`const`)**: Always use `const` constructors wherever possible to enable canonical instance reuse and prevent unnecessary widget rebuilds.
- **Granular Rebuild Scope**: Keep state listeners localized to leaf widgets using `Consumer`, `Selector`, or fine-grained builder widgets instead of rebuilding entire screen scaffolds.
- **Theme-Driven Styling (Design System)**: Never hardcode ad-hoc colors, paddings, or text styles across widgets. Derive values from `Theme.of(context)`, `ColorScheme`, `TextTheme`, or centralized design tokens.
- **Responsive & Adaptive Layouts**: Use `LayoutBuilder`, `MediaQuery`, and adaptive breakpoints so screens gracefully handle mobile portrait, tablet landscape, desktop, and web viewports.
- **Safe Resource Lifecycle**: Always dispose of `TextEditingController`, `ScrollController`, `AnimationController`, and `StreamSubscription` objects in `dispose()` hooks or Riverpod `ref.onDispose()`.
- **Isolate Heavy Repaints**: Wrap complex canvas paints, particle animations (e.g. confetti), and intensive streaming views in `RepaintBoundary`.

---

## 3. Material Design 3 (MD3) & Design Token Directives
- **Material 3 Enablement**: Always use `useMaterial3: true` in `ThemeData` with `ColorScheme.fromSeed()` or custom curated tonal palettes.
- **Semantic Color Roles**:
  - `primary` / `onPrimary`: Main prominent UI actions and high-emphasis highlights.
  - `primaryContainer` / `onPrimaryContainer`: Active states, floating pills, and tactical badges.
  - `surface` / `onSurface`: Main background and high-contrast text.
  - `surfaceContainerHighest` / `surfaceContainerLow`: Card layers, modal dialogs, and HUD scoreboards replacing heavy elevation shadows with tonal surface contrast.
- **8dp / 4dp Metric Grid Spacing**: Layout margins, paddings, and card gaps must strictly follow 4dp/8dp multiples (4, 8, 12, 16, 24, 32) for spatial consistency.
- **Expressive Typography**: Use standard Material 3 typescales (`displayLarge`, `titleMedium`, `labelSmall`, `bodyLarge`) derived from `Theme.of(context).textTheme`.

---

## 4. Dart 3+ Engineering & Type Safety
- **Sound Null Safety & Strict Typing**: Avoid `dynamic` and raw types. Explicitly annotate function parameters, generic collections, and return types.
- **Pattern Matching & Sealed Classes**: Use Dart 3+ sealed class hierarchies and pattern matching (`switch` expressions) for modeling UI states (e.g. `Initial`, `Loading`, `Success`, `Failure`).
- **Immutable Data Structures**: Favor immutable state models using `freezed`, `@immutable`, or `equatable` with `copyWith` methods for predictable state transitions.
- **Defensive Error Handling**: Catch specific exceptions (e.g. `DioException`, `SocketException`, `FormatException`) rather than bare `catch (e)`. Map low-level failures into user-friendly domain error messages.
- **Asynchronous Integrity**: Always handle `Future` and `Stream` states safely (loading, data, error). Never execute blocking synchronous calculations on the UI thread—offload heavy operations to `compute()` / `Isolate.run()`.

---

## 5. Single Source of Truth (SSOT) & API Contract Alignment
- **No Redundant State**: Do not maintain duplicate variables that represent the same state in slightly different forms. Derive computed state dynamically using selectors or provider getters.
- **Backend Schema Parity**: Data models must reflect exact backend API naming conventions using serialization annotations (e.g. `@JsonKey(name: 'move_delay_seconds')`) to maintain 1:1 contract alignment with the FastAPI backend.
- **Sensible Defaults & Fallbacks**: When optional backend fields are omitted or null, provide centralized, well-documented default values rather than ad-hoc inline null-coalescing (`??`) scattered across widgets.

---

## 6. The "Zero-Vestige" Refactoring & Sweeping Rule
- **Codebase-Wide Audits on Refactoring**: Whenever a model field, provider, route, or widget parameter is renamed, refactored, or deprecated:
  - **Never stop at the primary file**. Perform an exhaustive search across:
    1. **Data Models, DTOs & Serialization Schemas**
    2. **Repositories, Services & WebSocket Handlers**
    3. **State Notifiers, Providers & Controllers**
    4. **UI Screens, Widgets & Dialogs**
    5. **Unit, Widget, and Golden Test Suites**
    6. **Dart Docstrings (`///`) and Comments**
- **Eliminate Dead Code**: Immediately remove unused imports, dead controllers, stale aliases, and commented-out code blocks.

---

## 7. Automated Verification & Pre-Flight Checks
- **Self-Verification Protocol**: Before marking any Flutter task complete, verify:
  1. **Linter & Static Analysis**: Run `flutter analyze` or `dart analyze` with 0 warnings and 0 errors.
  2. **Automated Test Suites**: Run `flutter test` to ensure all unit and widget tests pass without regressions.
  3. **New Behavior Coverage**: Add corresponding unit tests for new state notifiers, data mappers, and edge cases.

---

## 8. Documentation & Comment Hygiene
- **Sync Documentation with Code**: Keep Dart docstrings (`///`), README specs, and architectural notes fully synchronized with implementation changes.
- **Explain "Why", Not "What"**: Comments must explain non-obvious architecture decisions, protocol quirks, timing considerations, or performance optimizations—never just rephrase readable Dart code.