import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'pump_golden.dart';

void main() {
  group('pumpGolden', () {
    testWidgets('renders the widget on a surface of the requested size', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        const Text('hello'),
        size: const Size(300, 600),
        devicePixelRatio: 2,
      );

      expect(find.text('hello'), findsOneWidget);
      expect(tester.view.physicalSize, const Size(300, 600));
      expect(tester.view.devicePixelRatio, 2);
    });

    testWidgets('applies the given theme', (tester) async {
      final theme = ThemeData(primaryColor: Colors.teal);

      await pumpGolden(tester, const Placeholder(), theme: theme);

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme?.primaryColor, Colors.teal);
    });
  });
}
