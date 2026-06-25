import 'package:academic_planner/src/shared/widgets/selectable_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('SelectableChipWidget', () {
    testWidgets('renders the label', (tester) async {
      await tester.pumpWidget(
        _harness(
          SelectableChipWidget(
            label: 'Matemática',
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Matemática'), findsOneWidget);
    });

    testWidgets('tap calls onTap', (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        _harness(
          SelectableChipWidget(
            label: 'Matemática',
            isSelected: false,
            onTap: () => calls++,
          ),
        ),
      );

      await tester.tap(find.byType(SelectableChipWidget));
      await tester.pumpAndSettle();

      expect(calls, 1);
    });

    testWidgets('isSelected true → uses the primary background and border', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          SelectableChipWidget(
            label: 'Matemática',
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      final context = tester.element(find.byType(SelectableChipWidget));
      final colorScheme = Theme.of(context).colorScheme;

      final chip = tester.widget<Chip>(find.byType(Chip));
      final shape = chip.shape! as RoundedRectangleBorder;

      expect(chip.backgroundColor, colorScheme.primary);
      expect(chip.labelStyle?.color, colorScheme.onPrimary);
      expect(shape.side.color, colorScheme.primary);
    });

    testWidgets(
      'isSelected false → uses a translucent label and no border color',
      (tester) async {
        await tester.pumpWidget(
          _harness(
            SelectableChipWidget(
              label: 'Matemática',
              isSelected: false,
              onTap: () {},
            ),
          ),
        );

        final context = tester.element(find.byType(SelectableChipWidget));
        final colorScheme = Theme.of(context).colorScheme;

        final chip = tester.widget<Chip>(find.byType(Chip));
        final shape = chip.shape! as RoundedRectangleBorder;

        expect(chip.backgroundColor, colorScheme.surface);
        expect(chip.labelStyle?.color, colorScheme.onSurface.withAlpha(160));
        expect(shape.side.color, Colors.transparent);
      },
    );
  });
}
