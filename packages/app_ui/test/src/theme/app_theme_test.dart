import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme.light', () {
    final theme = AppTheme.light();

    test('registers the light colour extension', () {
      expect(theme.extension<AppColors>(), AppColors.light);
    });

    test('derives its surfaces from the extension', () {
      expect(theme.scaffoldBackgroundColor, AppColors.light.background);
      expect(theme.colorScheme.surface, AppColors.light.surface);
      expect(theme.dividerTheme.color, AppColors.light.border);
      expect(theme.textSelectionTheme.cursorColor, AppColors.light.accent);
      expect(
        theme.textSelectionTheme.selectionColor,
        AppColors.light.selection,
      );
    });

    test('uses the brand colours for primary and error', () {
      expect(theme.colorScheme.primary, AppPalette.emerald700);
      expect(theme.colorScheme.error, AppPalette.red600);
    });

    test('applies the given text theme', () {
      const custom = TextTheme(bodyMedium: TextStyle(fontFamily: 'Custom'));

      expect(
        AppTheme.light(textTheme: custom).textTheme.bodyMedium?.fontFamily,
        'Custom',
      );
    });
  });

  group('AppTheme.dark', () {
    final theme = AppTheme.dark();

    test('registers the dark colour extension', () {
      expect(theme.extension<AppColors>(), AppColors.dark);
    });

    test('derives its surfaces from the extension', () {
      expect(theme.scaffoldBackgroundColor, AppColors.dark.background);
      expect(theme.colorScheme.surface, AppColors.dark.surface);
      expect(theme.appBarTheme.backgroundColor, AppColors.dark.background);
      expect(theme.dividerTheme.color, AppColors.dark.border);
      expect(theme.cardTheme.color, AppColors.dark.surface);
    });

    test('draws cards with a rounded border', () {
      final shape = theme.cardTheme.shape! as RoundedRectangleBorder;

      expect(shape.borderRadius, BorderRadius.circular(AppRadius.xxl));
      expect(shape.side.color, AppColors.dark.border);
    });

    test('applies the dark text colours on top of the given text theme', () {
      expect(theme.textTheme.bodyMedium?.color, AppPalette.slate300);
      expect(theme.textTheme.displayLarge?.color, AppPalette.white);
    });
  });
}
