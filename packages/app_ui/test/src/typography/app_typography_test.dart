import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const bundledWeights = [400, 500, 600, 700, 800];

  group('AppTypography', () {
    test('textTheme sets the bundled family on every style', () {
      final theme = AppTypography.textTheme(ThemeData.light().textTheme);

      for (final style in [
        theme.displayLarge,
        theme.titleMedium,
        theme.bodySmall,
        theme.labelLarge,
      ]) {
        expect(style?.fontFamily, 'packages/app_ui/PlusJakartaSans');
      }
    });

    test('style builds a TextStyle in the bundled family', () {
      final style = AppTypography.style(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.red,
        letterSpacing: 2,
        height: 1.5,
      );

      expect(style.fontFamily, 'packages/app_ui/PlusJakartaSans');
      expect(style.fontSize, 12);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.color, Colors.red);
      expect(style.letterSpacing, 2);
      expect(style.height, 1.5);
    });

    for (final weight in bundledWeights) {
      test('ships the $weight weight as an asset', () async {
        final data = await rootBundle.load(
          'assets/fonts/PlusJakartaSans-$weight.ttf',
        );

        expect(data.lengthInBytes, greaterThan(0));
      });
    }

    test('ships the font licence', () async {
      final licence = await rootBundle.loadString('assets/fonts/OFL.txt');

      expect(licence, contains('SIL Open Font License'));
    });
  });
}
