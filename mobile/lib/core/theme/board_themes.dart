import 'package:flutter/material.dart';

/// Defines colorway palette for the custom chessboard canvas.
class BoardTheme {
  final String id;
  final String name;
  final Color lightSquare;
  final Color darkSquare;
  final Color highlight;
  final Color checkGlow;

  const BoardTheme({
    required this.id,
    required this.name,
    required this.lightSquare,
    required this.darkSquare,
    required this.highlight,
    required this.checkGlow,
  });

  static const modernSlate = BoardTheme(
    id: 'slate',
    name: 'Modern Slate',
    lightSquare: Color(0xFF94A3B8),
    darkSquare: Color(0xFF334155),
    highlight: Color(0xFFF6F669),
    checkGlow: Color(0xFFFF6B6B),
  );

  static const emeraldGreen = BoardTheme(
    id: 'emerald',
    name: 'Emerald Green',
    lightSquare: Color(0xFFDCFCE7),
    darkSquare: Color(0xFF15803D),
    highlight: Color(0xFFF6F669),
    checkGlow: Color(0xFFFF4136),
  );

  static const classicWood = BoardTheme(
    id: 'wood',
    name: 'Classic Wood',
    lightSquare: Color(0xFFF0D9B5),
    darkSquare: Color(0xFFB58863),
    highlight: Color(0xFFCDD26A),
    checkGlow: Color(0xFFD9534F),
  );

  static const midnightOcean = BoardTheme(
    id: 'ocean',
    name: 'Midnight Ocean',
    lightSquare: Color(0xFFBFDBFE),
    darkSquare: Color(0xFF1E3A8A),
    highlight: Color(0xFFF6F669),
    checkGlow: Color(0xFFFF6363),
  );

  static const royalPurple = BoardTheme(
    id: 'purple',
    name: 'Royal Purple',
    lightSquare: Color(0xFFE9D5FF),
    darkSquare: Color(0xFF581C87),
    highlight: Color(0xFFF6D96B),
    checkGlow: Color(0xFFFF5C5C),
  );

  static const oledObsidian = BoardTheme(
    id: 'pitch',
    name: 'OLED Obsidian',
    lightSquare: Color(0xFF3F3F46),
    darkSquare: Color(0xFF18181B),
    highlight: Color(0xFFE6C200),
    checkGlow: Color(0xFFE63946),
  );

  static const List<BoardTheme> all = [
    modernSlate,
    emeraldGreen,
    classicWood,
    midnightOcean,
    royalPurple,
    oledObsidian,
  ];

  static BoardTheme fromId(String id) {
    return all.firstWhere(
      (theme) => theme.id == id,
      orElse: () => modernSlate,
    );
  }
}
