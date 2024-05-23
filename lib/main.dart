import 'package:flutter/material.dart';
import 'package:savetify/widgets/expenses.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 39, 165, 19),
);
var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 8, 38, 3),
);
void main() {
  runApp(MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        brightness: Brightness.dark,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        ),
      ),
      theme: ThemeData.dark().copyWith(
        colorScheme: kColorScheme,
        scaffoldBackgroundColor: const Color.fromARGB(255, 39, 165, 19),
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.error,
          foregroundColor: kColorScheme.scrim,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.secondaryContainer,
            foregroundColor: kDarkColorScheme.onSecondaryContainer,
          ),
        ),
        textTheme: const TextTheme().copyWith(
          titleLarge: TextStyle(
            color: kColorScheme.onSecondaryContainer,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const Expenses()));
}
