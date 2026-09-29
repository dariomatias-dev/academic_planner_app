import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors', () {
    test('light and dark differ on every semantic colour', () {
      expect(AppColors.light.background, isNot(AppColors.dark.background));
      expect(AppColors.light.surface, isNot(AppColors.dark.surface));
      expect(AppColors.light.border, isNot(AppColors.dark.border));
      expect(AppColors.light.accent, isNot(AppColors.dark.accent));
      expect(AppColors.light.selection, isNot(AppColors.dark.selection));
    });

    test('copyWith replaces only the given colours', () {
      final copy = AppColors.light.copyWith(accent: Colors.pink);

      expect(copy.accent, Colors.pink);
      expect(copy.background, AppColors.light.background);
      expect(copy.surface, AppColors.light.surface);
      expect(copy.border, AppColors.light.border);
      expect(copy.selection, AppColors.light.selection);
    });

    test('lerp interpolates between two palettes', () {
      final start = AppColors.light.lerp(AppColors.dark, 0);
      final end = AppColors.light.lerp(AppColors.dark, 1);
      final middle = AppColors.light.lerp(AppColors.dark, 0.5);

      expect(start.background, AppColors.light.background);
      expect(end.background, AppColors.dark.background);
      expect(
        middle.background,
        Color.lerp(
          AppColors.light.background,
          AppColors.dark.background,
          0.5,
        ),
      );
    });

    test('lerp with another type of extension returns itself', () {
      expect(AppColors.light.lerp(null, 0.5), AppColors.light);
    });

    testWidgets('context.appColors reads the theme extension', (tester) async {
      late AppColors read;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          home: Builder(
            builder: (context) {
              read = context.appColors;

              return const SizedBox();
            },
          ),
        ),
      );

      expect(read, AppColors.dark);
    });
  });
}
