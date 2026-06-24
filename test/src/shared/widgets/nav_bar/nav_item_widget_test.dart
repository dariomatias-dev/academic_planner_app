import 'package:academic_planner/src/shared/widgets/nav_bar/nav_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Row(children: [child])),
  );
}

void main() {
  group('NavItemWidget', () {
    testWidgets('renders the icon and label', (tester) async {
      await tester.pumpWidget(
        _harness(
          NavItemWidget(
            icon: Icons.grid_view_rounded,
            label: 'Início',
            index: 0,
            isSelected: false,
            onTap: (_) {},
          ),
        ),
      );

      expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
      expect(find.text('Início'), findsOneWidget);
    });

    testWidgets('tap calls onTap with its index', (tester) async {
      int? tapped;

      await tester.pumpWidget(
        _harness(
          NavItemWidget(
            icon: Icons.grid_view_rounded,
            label: 'Início',
            index: 2,
            isSelected: false,
            onTap: (index) => tapped = index,
          ),
        ),
      );

      await tester.tap(find.text('Início'));
      await tester.pumpAndSettle();

      expect(tapped, 2);
    });

    testWidgets('isSelected true → uses the active color and bold weight', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          NavItemWidget(
            icon: Icons.grid_view_rounded,
            label: 'Início',
            index: 0,
            isSelected: true,
            onTap: (_) {},
          ),
        ),
      );

      final context = tester.element(find.text('Início'));
      final colorScheme = Theme.of(context).colorScheme;

      final icon = tester.widget<Icon>(find.byIcon(Icons.grid_view_rounded));
      expect(icon.color, colorScheme.primary);

      final textStyle = tester
          .widget<AnimatedDefaultTextStyle>(
            find.descendant(
              of: find.byType(NavItemWidget),
              matching: find.byType(AnimatedDefaultTextStyle),
            ),
          )
          .style;
      expect(textStyle.color, colorScheme.primary);
      expect(textStyle.fontWeight, FontWeight.w800);

      final scale = tester
          .widget<AnimatedScale>(
            find.descendant(
              of: find.byType(NavItemWidget),
              matching: find.byType(AnimatedScale),
            ),
          )
          .scale;
      expect(scale, 1.15);
    });

    testWidgets(
      'isSelected false → uses the inactive color and regular weight',
      (tester) async {
        await tester.pumpWidget(
          _harness(
            NavItemWidget(
              icon: Icons.grid_view_rounded,
              label: 'Início',
              index: 0,
              isSelected: false,
              onTap: (_) {},
            ),
          ),
        );

        final context = tester.element(find.text('Início'));
        final inactiveColor = Theme.of(
          context,
        ).colorScheme.onSurface.withAlpha(153);

        final icon = tester.widget<Icon>(
          find.byIcon(Icons.grid_view_rounded),
        );
        expect(icon.color, inactiveColor);

        final textStyle = tester
            .widget<AnimatedDefaultTextStyle>(
              find.descendant(
                of: find.byType(NavItemWidget),
                matching: find.byType(AnimatedDefaultTextStyle),
              ),
            )
            .style;
        expect(textStyle.color, inactiveColor);
        expect(textStyle.fontWeight, FontWeight.w600);

        final scale = tester
            .widget<AnimatedScale>(
              find.descendant(
                of: find.byType(NavItemWidget),
                matching: find.byType(AnimatedScale),
              ),
            )
            .scale;
        expect(scale, 1.0);
      },
    );
  });
}
