import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'pump_golden.dart';

/// Renders [widget] in the light and dark themes and compares each with
/// `goldens/<name>_light.png` / `goldens/<name>_dark.png`, next to the test
/// file. Regenerate with `flutter test --update-goldens`.
Future<void> expectGolden(
  WidgetTester tester,
  Widget widget,
  String name, {
  Size size = const Size(400, 400),
}) async {
  final themes = {'light': AppTheme.light(), 'dark': AppTheme.dark()};

  for (final entry in themes.entries) {
    await pumpGolden(tester, widget, size: size, theme: entry.value);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/${name}_${entry.key}.png'),
    );
  }
}
