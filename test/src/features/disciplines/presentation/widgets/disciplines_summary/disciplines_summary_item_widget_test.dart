import 'package:academic_planner/src/features/disciplines/presentation/widgets/disciplines_summary/disciplines_summary_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  testWidgets('DisciplinesSummaryItemWidget renders the icon, value and '
      'label', (tester) async {
    await tester.pumpWidget(
      _harness(
        const DisciplinesSummaryItemWidget(
          icon: Icons.grid_view_rounded,
          label: 'Disciplinas',
          value: '8',
        ),
      ),
    );

    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('Disciplinas'), findsOneWidget);
  });
}
