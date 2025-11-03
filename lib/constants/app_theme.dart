import 'package:flutter/material.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF6C5CE7);
  static const String _fontFamily = 'SF Pro Display';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      ),
      fontFamily: _fontFamily,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
      ),
      fontFamily: _fontFamily,
    );
  }
}
