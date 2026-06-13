import 'package:flutter/material.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.secondary,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondary,
      shadowColor: AppColors.secondary,
      foregroundColor: AppColors.primary,
    ),

    textTheme: TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),

      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),

      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),

      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      ),

      bodyMedium: GoogleFonts.plusJakartaSans(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),

      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    primaryColor: AppColors.primary,
    splashColor: AppColors.secondary,
    brightness: Brightness.light,
  );
}
