import 'package:academic_planner/src/shared/widgets/buttons/action_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Row(children: [child])),
  );
}

void main() {
  group('ActionButtonWidget', () {
    testWidgets('renders label and icon', (tester) async {
      await tester.pumpWidget(
        _harness(
          ActionButtonWidget(
            icon: Icons.add,
            label: 'Adicionar',
            onPressed: () {},
            style: AppButtonStyle.primary,
          ),
        ),
      );

      expect(find.text('Adicionar'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('tap calls onPressed', (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        _harness(
          ActionButtonWidget(
            icon: Icons.add,
            label: 'Adicionar',
            onPressed: () => calls++,
            style: AppButtonStyle.primary,
          ),
        ),
      );

      await tester.tap(find.text('Adicionar'));
      await tester.pumpAndSettle();

      expect(calls, 1);
    });

    testWidgets('expands to fill the Row and forwards isFullWidth', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          ActionButtonWidget(
            icon: Icons.add,
            label: 'Adicionar',
            onPressed: () {},
            style: AppButtonStyle.primary,
          ),
        ),
      );

      expect(find.byType(Expanded), findsOneWidget);

      final buttonWidget = tester.widget<ButtonWidget>(
        find.byType(ButtonWidget),
      );

      expect(buttonWidget.isFullWidth, isTrue);
      expect(buttonWidget.height, 64.0);
      expect(buttonWidget.style, AppButtonStyle.primary);
    });
  });
}
