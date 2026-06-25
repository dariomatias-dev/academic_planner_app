import 'package:academic_planner/src/shared/widgets/switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

BoxDecoration _decorationOf(Container container) {
  return container.decoration! as BoxDecoration;
}

void main() {
  group('SwitchWidget', () {
    testWidgets('value false → tap calls onChanged with true', (
      tester,
    ) async {
      bool? newValue;

      await tester.pumpWidget(
        _harness(
          SwitchWidget(value: false, onChanged: (value) => newValue = value),
        ),
      );

      await tester.tap(find.byType(SwitchWidget));
      await tester.pumpAndSettle();

      expect(newValue, isTrue);
    });

    testWidgets('value true → tap calls onChanged with false', (
      tester,
    ) async {
      bool? newValue;

      await tester.pumpWidget(
        _harness(
          SwitchWidget(value: true, onChanged: (value) => newValue = value),
        ),
      );

      await tester.tap(find.byType(SwitchWidget));
      await tester.pumpAndSettle();

      expect(newValue, isFalse);
    });

    testWidgets(
      'value true → aligns the knob to the right and highlights it',
      (tester) async {
        await tester.pumpWidget(
          _harness(SwitchWidget(value: true, onChanged: (_) {})),
        );

        final context = tester.element(find.byType(SwitchWidget));
        final colorScheme = Theme.of(context).colorScheme;

        final align = tester.widget<AnimatedAlign>(
          find.byType(AnimatedAlign),
        );
        expect(align.alignment, Alignment.centerRight);

        final track = tester.widget<Container>(
          find.ancestor(
            of: find.byType(AnimatedAlign),
            matching: find.byType(Container),
          ),
        );
        final knob = tester.widget<Container>(
          find.descendant(
            of: find.byType(AnimatedAlign),
            matching: find.byType(Container),
          ),
        );

        expect(_decorationOf(track).color, colorScheme.primary.withAlpha(30));
        expect(
          _decorationOf(track).border,
          Border.all(color: colorScheme.primary.withAlpha(80), width: 2.0),
        );
        expect(_decorationOf(knob).color, colorScheme.primary);
        expect(_decorationOf(knob).boxShadow, isNotEmpty);
      },
    );

    testWidgets('value false → aligns the knob to the left, dims it', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(SwitchWidget(value: false, onChanged: (_) {})),
      );

      final context = tester.element(find.byType(SwitchWidget));
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      final align = tester.widget<AnimatedAlign>(find.byType(AnimatedAlign));
      expect(align.alignment, Alignment.centerLeft);

      final track = tester.widget<Container>(
        find.ancestor(
          of: find.byType(AnimatedAlign),
          matching: find.byType(Container),
        ),
      );
      final knob = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimatedAlign),
          matching: find.byType(Container),
        ),
      );

      expect(_decorationOf(track).color, colorScheme.surface);
      expect(
        _decorationOf(track).border,
        Border.all(
          color: theme.dividerTheme.color ?? Colors.transparent,
          width: 2.0,
        ),
      );
      expect(_decorationOf(knob).color, colorScheme.onSurface.withAlpha(60));
      expect(_decorationOf(knob).boxShadow, isEmpty);
    });
  });
}
