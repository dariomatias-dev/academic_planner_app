import 'package:academic_planner/src/shared/widgets/buttons/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: Center(child: child)));
}

void main() {
  group('TextButtonWidget', () {
    testWidgets('renders the text', (tester) async {
      await tester.pumpWidget(
        _harness(TextButtonWidget(text: 'Cancelar', onTap: () {})),
      );

      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('tap calls onTap', (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        _harness(TextButtonWidget(text: 'Cancelar', onTap: () => calls++)),
      );

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(calls, 1);
    });

    testWidgets('uses colorScheme.primary as text color', (tester) async {
      await tester.pumpWidget(
        _harness(TextButtonWidget(text: 'Cancelar', onTap: () {})),
      );

      final context = tester.element(find.text('Cancelar'));
      final expectedColor = Theme.of(context).colorScheme.primary;

      final textWidget = tester.widget<Text>(find.text('Cancelar'));

      expect(textWidget.style?.color, expectedColor);
    });
  });
}
