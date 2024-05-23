import 'package:flutter/material.dart';

class SavetifyTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Use Material 3 design principles
    brightness: Brightness.light,
    primaryColor: const Color(0xFF4CAF50), // Green accent
    secondaryHeaderColor: const Color(0xFF2196F3), // Blue accent
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4CAF50),
      titleTextStyle: TextStyle(color: Colors.white),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(), // Default body text
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4CAF50),
      brightness: Brightness.light,
    ),
    cardTheme: const CardTheme(
      elevation: 2,
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50), // Green button background
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2196F3), // Blue FAB
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF4CAF50),
    secondaryHeaderColor: const Color(0xFF2196F3),
    scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2196F3),
      titleTextStyle: TextStyle(color: Colors.white),
    ),
    textTheme: const TextTheme(
      headlineMedium:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge:
          TextStyle(color: Colors.white), // White text on dark background
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4CAF50),
      brightness: Brightness.dark,
    ),
    cardTheme: const CardTheme(
      elevation: 2,
      color: Color(0xFF1E1E1E), // Dark card background
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2196F3),
      foregroundColor: Colors.white,
    ),
  );
}
