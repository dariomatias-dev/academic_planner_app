import 'package:app_ui/src/colors/app_colors.dart';
import 'package:app_ui/src/colors/app_palette.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// The app's light and dark [ThemeData]. Each registers the matching
/// [AppColors] extension and derives its surfaces from it.
abstract final class AppTheme {
  static ThemeData light() {
    const colors = AppColors.light;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colors.background,
      textTheme: AppTypography.textTheme(ThemeData.light().textTheme),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppPalette.emerald700,
        primary: AppPalette.emerald700,
        secondary: AppPalette.emerald500,
        surface: colors.surface,
        onSurface: AppPalette.slate800,
        error: AppPalette.red600,
        onError: AppPalette.white,
        errorContainer: AppPalette.red50,
        onErrorContainer: AppPalette.red700,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.accent,
        selectionColor: colors.selection,
        selectionHandleColor: colors.accent,
      ),
      dividerTheme: DividerThemeData(color: colors.border, thickness: 1),
      extensions: const [colors],
    );
  }

  static ThemeData dark() {
    const colors = AppColors.dark;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colors.background,
      textTheme: AppTypography.textTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppPalette.slate300,
        displayColor: AppPalette.white,
      ),
      colorScheme: ColorScheme.dark(
        primary: AppPalette.emerald500,
        secondary: AppPalette.emerald600,
        surface: colors.surface,
        onSurfaceVariant: AppPalette.emerald400,
        error: AppPalette.red600,
        onError: AppPalette.white,
        errorContainer: AppPalette.red950,
        onErrorContainer: AppPalette.red500,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        surfaceTintColor: AppPalette.transparent,
        elevation: 0,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.accent,
        selectionColor: colors.selection,
        selectionHandleColor: colors.accent,
      ),
      dividerTheme: DividerThemeData(color: colors.border, thickness: 1),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          side: BorderSide(color: colors.border),
        ),
      ),
      extensions: const [colors],
    );
  }
}
