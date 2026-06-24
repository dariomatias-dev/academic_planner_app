import 'package:academic_planner/src/shared/widgets/periods_tab_bar/period_tab_item_widget.dart';
import 'package:academic_planner/src/shared/widgets/periods_tab_bar/periods_tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('PeriodsTabBarWidget', () {
    testWidgets('renders one tab per period with its label', (tester) async {
      final controller = TabController(length: 3, vsync: const TestVSync());
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          PeriodsTabBarWidget(controller: controller, periods: const [1, 2, 3]),
        ),
      );

      expect(find.text('1º Período'), findsOneWidget);
      expect(find.text('2º Período'), findsOneWidget);
      expect(find.text('3º Período'), findsOneWidget);
    });

    testWidgets('marks only the tab at the controller index as selected', (
      tester,
    ) async {
      final controller = TabController(
        length: 3,
        initialIndex: 1,
        vsync: const TestVSync(),
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          PeriodsTabBarWidget(controller: controller, periods: const [1, 2, 3]),
        ),
      );

      final items = tester
          .widgetList<PeriodTabItemWidget>(
            find.byType(PeriodTabItemWidget),
          )
          .toList();

      expect(items[0].isSelected, isFalse);
      expect(items[1].isSelected, isTrue);
      expect(items[2].isSelected, isFalse);
    });

    testWidgets('tap on a tab moves the controller to its index', (
      tester,
    ) async {
      final controller = TabController(length: 3, vsync: const TestVSync());
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          PeriodsTabBarWidget(controller: controller, periods: const [1, 2, 3]),
        ),
      );

      expect(controller.index, 0);

      await tester.tap(find.text('3º Período'));
      await tester.pumpAndSettle();

      expect(controller.index, 2);
    });
  });
}
