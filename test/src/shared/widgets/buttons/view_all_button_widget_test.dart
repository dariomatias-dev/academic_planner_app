import 'package:academic_planner/src/shared/widgets/buttons/view_all_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: Center(child: child)));
}

void main() {
  group('ViewAllButtonWidget', () {
    testWidgets('renders the "Ver Todas" label', (tester) async {
      await tester.pumpWidget(_harness(ViewAllButtonWidget(onTap: () {})));

      expect(find.text('Ver Todas'), findsOneWidget);
    });

    testWidgets('tap calls onTap', (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        _harness(ViewAllButtonWidget(onTap: () => calls++)),
      );

      await tester.tap(find.text('Ver Todas'));
      await tester.pumpAndSettle();

      expect(calls, 1);
    });

    testWidgets('uses colorScheme.primary as text color', (tester) async {
      await tester.pumpWidget(_harness(ViewAllButtonWidget(onTap: () {})));

      final context = tester.element(find.text('Ver Todas'));
      final expectedColor = Theme.of(context).colorScheme.primary;

      final textWidget = tester.widget<Text>(find.text('Ver Todas'));

      expect(textWidget.style?.color, expectedColor);
    });
  });
}
