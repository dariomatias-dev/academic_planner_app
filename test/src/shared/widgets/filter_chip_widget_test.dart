import 'package:academic_planner/src/shared/widgets/filter_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('FilterChipWidget', () {
    testWidgets('renders the label', (tester) async {
      await tester.pumpWidget(
        _harness(
          FilterChipWidget(
            label: 'Matemática',
            isSelected: false,
            onSelected: (_) {},
          ),
        ),
      );

      expect(find.text('Matemática'), findsOneWidget);
    });

    testWidgets('tap calls onSelected with the toggled value', (
      tester,
    ) async {
      bool? selected;

      await tester.pumpWidget(
        _harness(
          FilterChipWidget(
            label: 'Matemática',
            isSelected: false,
            onSelected: (value) => selected = value,
          ),
        ),
      );

      await tester.tap(find.byType(FilterChip));
      await tester.pumpAndSettle();

      expect(selected, isTrue);
    });

    testWidgets('isSelected true → uses the primary background', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          FilterChipWidget(
            label: 'Matemática',
            isSelected: true,
            onSelected: (_) {},
          ),
        ),
      );

      final context = tester.element(find.byType(FilterChipWidget));
      final colorScheme = Theme.of(context).colorScheme;

      final chip = tester.widget<FilterChip>(find.byType(FilterChip));

      expect(chip.selected, isTrue);
      expect(chip.backgroundColor, colorScheme.surface);
      expect(chip.selectedColor, colorScheme.primary);
      expect(chip.checkmarkColor, colorScheme.onPrimary);
      expect(chip.labelStyle?.color, colorScheme.onPrimary);
    });

    testWidgets('isSelected false → uses a translucent onSurface label', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          FilterChipWidget(
            label: 'Matemática',
            isSelected: false,
            onSelected: (_) {},
          ),
        ),
      );

      final context = tester.element(find.byType(FilterChipWidget));
      final colorScheme = Theme.of(context).colorScheme;

      final chip = tester.widget<FilterChip>(find.byType(FilterChip));

      expect(chip.selected, isFalse);
      expect(
        chip.labelStyle?.color,
        colorScheme.onSurface.withAlpha(160),
      );
    });
  });
}
