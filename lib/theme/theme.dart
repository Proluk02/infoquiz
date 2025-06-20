import 'package:flutter/material.dart';

final ThemeData infoquizTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF0E4D92), // Bleu profond
    secondary: const Color(0xFF48CAE4), // Bleu clair moderne
    background: const Color(0xFFF1F5F9), // Gris très clair
    error: const Color(0xFFEF4444), // Rouge moderne
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
  scaffoldBackgroundColor: const Color(0xFFF1F5F9),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0E4D92),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Color(0xFF0F172A),
      fontWeight: FontWeight.w700,
      fontSize: 30,
    ),
    headlineSmall: TextStyle(
      color: Color(0xFF1E293B),
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
    bodyMedium: TextStyle(color: Color(0xFF334155), fontSize: 16),
    labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF48CAE4),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF0E4D92), width: 2),
    ),
    labelStyle: const TextStyle(color: Color(0xFF1E293B)),
  ),
);
