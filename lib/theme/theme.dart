import 'package:flutter/material.dart';

final ThemeData infoquizTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF1C4D57),
  scaffoldBackgroundColor: const Color(0xFFE9F6E3),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1C4D57),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFA6F100),
    primary: const Color(0xFF1C4D57),
    secondary: const Color(0xFFA6F100),
    background: const Color(0xFFE9F6E3),
    error: const Color(0xFFFF5E5E),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Color(0xFF0F2A30),
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
    bodyMedium: TextStyle(color: Color(0xFF0F2A30), fontSize: 16),
    labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFA6F100),
      foregroundColor: const Color(0xFF0F2A30),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF1C4D57)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFA6F100), width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);
