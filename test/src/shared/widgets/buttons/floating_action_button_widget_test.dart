import 'package:academic_planner/src/shared/widgets/buttons/floating_action_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: Center(child: child)));
}

void main() {
  group('FloatingActionButtonWidget', () {
    testWidgets('renders the icon', (tester) async {
      await tester.pumpWidget(
        _harness(
          FloatingActionButtonWidget(icon: Icons.add, onPressed: () {}),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('tap calls onPressed', (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        _harness(
          FloatingActionButtonWidget(
            icon: Icons.add,
            onPressed: () => calls++,
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(calls, 1);
    });

    testWidgets('uses colorScheme.primary as background', (tester) async {
      await tester.pumpWidget(
        _harness(
          FloatingActionButtonWidget(icon: Icons.add, onPressed: () {}),
        ),
      );

      final context = tester.element(find.byType(FloatingActionButton));
      final colorScheme = Theme.of(context).colorScheme;

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );

      expect(fab.backgroundColor, colorScheme.primary);

      final icon = tester.widget<Icon>(find.byIcon(Icons.add));
      expect(icon.color, colorScheme.onPrimary);
    });

    testWidgets('forwards heroTag', (tester) async {
      await tester.pumpWidget(
        _harness(
          FloatingActionButtonWidget(
            icon: Icons.add,
            heroTag: 'fab-tag',
            onPressed: () {},
          ),
        ),
      );

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );

      expect(fab.heroTag, 'fab-tag');
    });
  });
}
