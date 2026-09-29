import 'package:app_ui/src/colors/app_palette.dart';
import 'package:flutter/material.dart';

/// Semantic colours that differ between the light and dark themes. Read them
/// with `context.appColors` instead of picking palette values by hand.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.border,
    required this.accent,
    required this.selection,
  });

  static const light = AppColors(
    background: AppPalette.slate100,
    surface: AppPalette.white,
    border: AppPalette.slate200,
    accent: AppPalette.emerald600,
    selection: AppPalette.selectionLight,
  );

  static const dark = AppColors(
    background: AppPalette.zinc950,
    surface: AppPalette.black,
    border: AppPalette.zinc800,
    accent: AppPalette.emerald500,
    selection: AppPalette.selectionDark,
  );

  /// Scaffold background.
  final Color background;

  /// Cards, sheets and other raised surfaces.
  final Color surface;

  /// Dividers and outlines.
  final Color border;

  /// Cursor, selection handles and other accent highlights.
  final Color accent;

  /// Text selection highlight.
  final Color selection;

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? border,
    Color? accent,
    Color? selection,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      border: border ?? this.border,
      accent: accent ?? this.accent,
      selection: selection ?? this.selection,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;

    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      selection: Color.lerp(selection, other.selection, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  /// The [AppColors] of the ambient theme. The theme must come from
  /// `AppTheme`, which registers the extension.
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
