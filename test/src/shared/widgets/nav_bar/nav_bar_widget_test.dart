import 'package:academic_planner/src/shared/widgets/nav_bar/nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Stack(children: [child])),
  );
}

void main() {
  group('NavBarWidget', () {
    testWidgets('renders all four items with their labels and icons', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(NavBarWidget(selectedIndex: 0, onTap: (_) {})),
      );

      expect(find.text('Início'), findsOneWidget);
      expect(find.text('Grade'), findsOneWidget);
      expect(find.text('Atividades'), findsOneWidget);
      expect(find.text('Ajustes'), findsOneWidget);

      expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
      expect(find.byIcon(Icons.task_alt_rounded), findsOneWidget);
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
    });

    testWidgets('tap on an item calls onTap with its index', (tester) async {
      int? tapped;

      await tester.pumpWidget(
        _harness(
          NavBarWidget(selectedIndex: 0, onTap: (index) => tapped = index),
        ),
      );

      await tester.tap(find.text('Atividades'));
      await tester.pumpAndSettle();

      expect(tapped, 2);
    });

    testWidgets('selectedIndex → highlights only the matching item', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(NavBarWidget(selectedIndex: 2, onTap: (_) {})),
      );

      final context = tester.element(find.text('Início'));
      final colorScheme = Theme.of(context).colorScheme;
      final inactiveColor = colorScheme.onSurface.withAlpha(153);

      expect(
        tester.widget<Icon>(find.byIcon(Icons.grid_view_rounded)).color,
        inactiveColor,
      );
      expect(
        tester.widget<Icon>(find.byIcon(Icons.calendar_today_rounded)).color,
        inactiveColor,
      );
      expect(
        tester.widget<Icon>(find.byIcon(Icons.task_alt_rounded)).color,
        colorScheme.primary,
      );
      expect(
        tester.widget<Icon>(find.byIcon(Icons.settings_rounded)).color,
        inactiveColor,
      );
    });
  });
}
