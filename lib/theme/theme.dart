import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2563EB); // Bleu royal (accent)
  static const Color secondary = Color(0xFFF59E0B); // Jaune safran subtil
  static const Color dark = Color(0xFF1E293B); // Bleu nuit très pro
  static const Color background = Color(0xFFF9FAFB); // Blanc cassé élégant
  static const Color surface = Color(0xFFFFFFFF); // Blanc pur pour les cartes
  static const Color border = Color(0xFFE5E7EB); // Gris clair élégant
  static const Color error = Color(0xFFDC2626); // Rouge sobre
  static const Color text = Color(0xFF0F172A); // Bleu-graphite (très lisible)
}

final ThemeData infoquizTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'Poppins',

  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    background: AppColors.background,
    surface: AppColors.surface,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.text,
    onBackground: AppColors.text,
    onError: Colors.white,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),

  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: AppColors.text,
      fontWeight: FontWeight.w700,
      fontSize: 28,
    ),
    headlineSmall: TextStyle(
      color: AppColors.text,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
    bodyMedium: TextStyle(color: AppColors.text, fontSize: 16),
    labelLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    labelStyle: const TextStyle(color: AppColors.text),
  ),
);
