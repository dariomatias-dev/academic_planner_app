import 'package:flutter/material.dart';

/// The bundled typeface (Plus Jakarta Sans, SIL Open Font License, see
/// `assets/fonts/OFL.txt`). Weights 400 to 800 ship as static files; weight
/// 900 renders with the 800 file.
abstract final class AppTypography {
  static const String fontFamily = 'PlusJakartaSans';

  /// Package that owns the font assets.
  static const String package = 'app_ui';

  /// [base] with every style set in the bundled typeface.
  static TextTheme textTheme(TextTheme base) {
    return base.apply(fontFamily: fontFamily, package: package);
  }

  /// A [TextStyle] in the bundled typeface, for text outside the theme.
  static TextStyle style({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      package: package,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}
