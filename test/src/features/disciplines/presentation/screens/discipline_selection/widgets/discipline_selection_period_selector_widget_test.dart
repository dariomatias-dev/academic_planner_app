import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_selection/widgets/discipline_selection_period_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('DisciplineSelectionPeriodSelectorWidget', () {
    testWidgets('renders one chip per period', (tester) async {
      final controller = TabController(length: 3, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          DisciplineSelectionPeriodSelectorWidget(
            controller: controller,
            periods: const [1, 2, 3],
          ),
        ),
      );

      expect(find.text('1º Período'), findsOneWidget);
      expect(find.text('2º Período'), findsOneWidget);
      expect(find.text('3º Período'), findsOneWidget);
    });

    testWidgets('tapping a period tab updates the controller index', (
      tester,
    ) async {
      final controller = TabController(length: 3, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          DisciplineSelectionPeriodSelectorWidget(
            controller: controller,
            periods: const [1, 2, 3],
          ),
        ),
      );

      await tester.tap(find.text('3º Período'));
      await tester.pumpAndSettle();

      expect(controller.index, 2);
    });
  });
}
