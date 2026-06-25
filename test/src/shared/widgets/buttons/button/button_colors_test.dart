import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_colors.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final theme = ThemeData.light();
  final colorScheme = theme.colorScheme;

  group('AppButtonStyles.fromStyle', () {
    test('primary → primary background, onPrimary text, no border', () {
      final styles = AppButtonStyles.fromStyle(AppButtonStyle.primary, theme);

      expect(styles.backgroundColor, colorScheme.primary);
      expect(styles.textColor, colorScheme.onPrimary);
      expect(styles.borderColor, isNull);
      expect(styles.iconBackgroundColor, isNull);
    });

    test('secondary → translucent primary background, primary text', () {
      final styles = AppButtonStyles.fromStyle(
        AppButtonStyle.secondary,
        theme,
      );

      expect(styles.backgroundColor, colorScheme.primary.withAlpha(25));
      expect(styles.textColor, colorScheme.primary);
      expect(styles.borderColor, isNull);
      expect(styles.iconBackgroundColor, isNull);
    });

    test('neutral → scaffold background, onSurface text, divider border', () {
      final styles = AppButtonStyles.fromStyle(AppButtonStyle.neutral, theme);

      expect(styles.backgroundColor, theme.scaffoldBackgroundColor);
      expect(styles.textColor, colorScheme.onSurface);
      expect(styles.borderColor, theme.dividerTheme.color);
      expect(styles.iconBackgroundColor, isNull);
    });

    test('outline → transparent background, primary text and border', () {
      final styles = AppButtonStyles.fromStyle(AppButtonStyle.outline, theme);

      expect(styles.backgroundColor, AppColors.transparent);
      expect(styles.textColor, colorScheme.primary);
      expect(styles.borderColor, colorScheme.primary);
      expect(styles.iconBackgroundColor, isNull);
    });

    test('destructive → errorContainer background, error text and icon bg', () {
      final styles = AppButtonStyles.fromStyle(
        AppButtonStyle.destructive,
        theme,
      );

      expect(styles.backgroundColor, colorScheme.errorContainer);
      expect(styles.textColor, colorScheme.error);
      expect(styles.borderColor, isNull);
      expect(styles.iconBackgroundColor, colorScheme.error.withAlpha(40));
    });

    test('destructiveSolid → error background, onError text, no border', () {
      final styles = AppButtonStyles.fromStyle(
        AppButtonStyle.destructiveSolid,
        theme,
      );

      expect(styles.backgroundColor, colorScheme.error);
      expect(styles.textColor, colorScheme.onError);
      expect(styles.borderColor, isNull);
      expect(styles.iconBackgroundColor, isNull);
    });
  });
}
