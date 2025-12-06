import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.accentPurple,
      scaffoldBackgroundColor: AppColors.primaryDarkColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accentPurple,
        brightness: Brightness.dark,
        primary: AppColors.accentPurple,
        onPrimary: AppColors.textColorLight,
        secondary: AppColors.warningColor,
        onSecondary: AppColors.textColorDark,
        surface: AppColors.inputFieldBackground,
        onSurface: AppColors.textColorLight,
        error: AppColors.dangerColor,
        onError: AppColors.textColorLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryDarkColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.textColorLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.textColorLight),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFieldBackground,
        labelStyle: const TextStyle(color: AppColors.textColorLight),
        hintStyle: TextStyle(
          color: AppColors.textColorLight.withAlpha((0.6 * 255).round()),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.inputFieldBorder,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.inputFieldBorder,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.accentPurple,
            width: 2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPurple,
          foregroundColor: AppColors.textColorLight,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentPurple,
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.inputFieldBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
