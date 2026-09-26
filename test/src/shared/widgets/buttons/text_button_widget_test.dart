import 'package:academic_planner/src/shared/widgets/buttons/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  group('TextButtonWidget', () {
    testWidgets('renders the text', (tester) async {
      await pumpApp(tester, TextButtonWidget(text: 'Cancelar', onTap: () {}));

      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('tap calls onTap', (tester) async {
      var calls = 0;

      await pumpApp(
        tester,
        TextButtonWidget(text: 'Cancelar', onTap: () => calls++),
      );

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(calls, 1);
    });

    testWidgets('uses colorScheme.primary as text color', (tester) async {
      await pumpApp(tester, TextButtonWidget(text: 'Cancelar', onTap: () {}));

      final context = tester.element(find.text('Cancelar'));
      final expectedColor = Theme.of(context).colorScheme.primary;

      final textWidget = tester.widget<Text>(find.text('Cancelar'));

      expect(textWidget.style?.color, expectedColor);
    });
  });
}
