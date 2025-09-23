import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: TextTheme(
      bodyLarge: AppFonts.body,
      headlineLarge: AppFonts.headline,
    ),
    useMaterial3: true,
  );
}
