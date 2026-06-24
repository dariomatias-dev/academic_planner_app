import 'package:academic_planner/src/shared/widgets/periods_tab_bar/period_tab_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('PeriodTabItemWidget', () {
    testWidgets('renders the period label', (tester) async {
      await tester.pumpWidget(
        _harness(const PeriodTabItemWidget(period: 3, isSelected: false)),
      );

      expect(find.text('3º Período'), findsOneWidget);
    });

    testWidgets('isSelected true → highlighted background, text and shadow', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(const PeriodTabItemWidget(period: 1, isSelected: true)),
      );

      final context = tester.element(find.text('1º Período'));
      final colorScheme = Theme.of(context).colorScheme;

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration! as BoxDecoration;

      expect(decoration.color, colorScheme.onSurface);
      expect(decoration.border!.top.color, colorScheme.onSurface);
      expect(decoration.boxShadow, isNotEmpty);

      final text = tester.widget<Text>(find.text('1º Período'));
      expect(text.style?.color, colorScheme.surface);
      expect(text.style?.fontWeight, FontWeight.w800);
    });

    testWidgets(
      'isSelected false → surface background, dimmed text and no shadow',
      (tester) async {
        await tester.pumpWidget(
          _harness(const PeriodTabItemWidget(period: 1, isSelected: false)),
        );

        final context = tester.element(find.text('1º Período'));
        final colorScheme = Theme.of(context).colorScheme;

        final container = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = container.decoration! as BoxDecoration;

        expect(decoration.color, colorScheme.surface);
        expect(decoration.boxShadow, isEmpty);

        final text = tester.widget<Text>(find.text('1º Período'));
        expect(text.style?.color, colorScheme.onSurface.withAlpha(160));
        expect(text.style?.fontWeight, FontWeight.w600);
      },
    );
  });
}
