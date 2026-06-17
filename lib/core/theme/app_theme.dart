import 'package:flutter/material.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    fontFamily: AppConstants.fontFamily,
    scaffoldBackgroundColor: AppColors.secondary,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondary,
      shadowColor: AppColors.secondary,
      foregroundColor: AppColors.primary,
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
