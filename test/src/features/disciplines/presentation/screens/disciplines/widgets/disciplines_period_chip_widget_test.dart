import 'package:academic_planner/src/features/disciplines/presentation/screens/disciplines/widgets/disciplines_period_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DisciplinesPeriodChipWidget', () {
    testWidgets('renders the label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DisciplinesPeriodChipWidget(
              label: '1º Período',
              isSelected: false,
            ),
          ),
        ),
      );

      expect(find.text('1º Período'), findsOneWidget);
    });

    testWidgets('selected → still renders the label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DisciplinesPeriodChipWidget(
              label: '1º Período',
              isSelected: true,
            ),
          ),
        ),
      );

      expect(find.text('1º Período'), findsOneWidget);
    });
  });
}
