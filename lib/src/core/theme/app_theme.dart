import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:academic_planner/src/core/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.slate50,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.emerald600,
        primary: AppColors.emerald600,
        secondary: AppColors.emerald500,
        surface: AppColors.white,
        onSurface: AppColors.slate800,
        brightness: Brightness.light,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.emerald600,
        selectionColor: AppColors.selectionLight,
        selectionHandleColor: AppColors.emerald600,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.slate200,
        thickness: 1.0,
      ),
    );
  }

  static ThemeData get dark {
    final baseDark = ThemeData.dark();
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.black,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        baseDark.textTheme,
      ).apply(bodyColor: AppColors.slate400, displayColor: AppColors.white),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.emerald500,
        secondary: AppColors.emerald400,
        surface: AppColors.zinc950,
        onSurface: AppColors.white,
        onSurfaceVariant: AppColors.emerald400,
        onPrimary: AppColors.black,
        error: AppColors.red500,
        errorContainer: AppColors.red950,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.black,
        surfaceTintColor: AppColors.transparent,
        elevation: 0.0,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.emerald500,
        selectionColor: AppColors.selectionDark,
        selectionHandleColor: AppColors.emerald500,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.zinc900,
        thickness: 1.0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.zinc950,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: const BorderSide(color: AppColors.zinc900, width: 1.0),
        ),
      ),
    );
  }
}
