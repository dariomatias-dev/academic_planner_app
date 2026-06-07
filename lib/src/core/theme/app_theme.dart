import 'package:academic_planner/src/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        error: AppColors.red600,
        onError: AppColors.white,
        errorContainer: AppColors.red50,
        onErrorContainer: AppColors.red700,
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
      ).apply(bodyColor: AppColors.slate300, displayColor: AppColors.white),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.emerald500,
        secondary: AppColors.emerald600,
        surface: AppColors.zinc950,
        onSurfaceVariant: AppColors.emerald400,
        error: AppColors.red600,
        onError: AppColors.white,
        errorContainer: AppColors.red950,
        onErrorContainer: AppColors.red500,
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
          side: const BorderSide(color: AppColors.zinc900),
        ),
      ),
    );
  }
}
