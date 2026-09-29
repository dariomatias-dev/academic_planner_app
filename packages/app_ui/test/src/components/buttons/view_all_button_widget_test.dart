import 'package:app_ui/src/components/buttons/view_all_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('ViewAllButtonWidget', () {
    testWidgets('renders the "Ver Todas" label', (tester) async {
      await pumpApp(
        tester,
        ViewAllButtonWidget(label: 'Ver Todas', onTap: () {}),
      );

      expect(find.text('Ver Todas'), findsOneWidget);
    });

    testWidgets('tap calls onTap', (tester) async {
      var calls = 0;

      await pumpApp(
        tester,
        ViewAllButtonWidget(label: 'Ver Todas', onTap: () => calls++),
      );

      await tester.tap(find.text('Ver Todas'));
      await tester.pumpAndSettle();

      expect(calls, 1);
    });

    testWidgets('uses colorScheme.primary as text color', (tester) async {
      await pumpApp(
        tester,
        ViewAllButtonWidget(label: 'Ver Todas', onTap: () {}),
      );

      final context = tester.element(find.text('Ver Todas'));
      final expectedColor = Theme.of(context).colorScheme.primary;

      final textWidget = tester.widget<Text>(find.text('Ver Todas'));

      expect(textWidget.style?.color, expectedColor);
    });
  });
}
