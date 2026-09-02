/// Core enumeration types defining match lifecycle, color sides, and AI providers.
library;

enum GameStatus {
  idle,
  playing,
  paused,
  finished,
}

enum PlayerColor {
  white,
  black;

  PlayerColor get opponent => this == PlayerColor.white ? PlayerColor.black : PlayerColor.white;
}

enum ProviderType {
  deepseek,
  openai,
  gemini,
  anthropic,
  groq,
  openrouter;

  String get displayName {
    switch (this) {
      case ProviderType.deepseek:
        return 'DeepSeek';
      case ProviderType.openai:
        return 'OpenAI';
      case ProviderType.gemini:
        return 'Google Gemini';
      case ProviderType.anthropic:
        return 'Anthropic';
      case ProviderType.groq:
        return 'Groq';
      case ProviderType.openrouter:
        return 'OpenRouter';
    }
  }
}
