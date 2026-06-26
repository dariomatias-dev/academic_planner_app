import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_stat_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DisciplineDetailsStatCardWidget renders the icon, value and '
      'label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DisciplineDetailsStatCardWidget(
            label: 'Carga Horária',
            value: '134h',
            icon: Icons.timer_outlined,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
    expect(find.text('134h'), findsOneWidget);
    expect(find.text('Carga Horária'), findsOneWidget);
  });
}
