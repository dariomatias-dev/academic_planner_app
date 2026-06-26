import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DisciplineDetailsHeaderWidget renders the period badge, '
      'name and acronym', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DisciplineDetailsHeaderWidget(
            acronym: 'Algo',
            name: 'Algoritmos e Lógica de Programação',
            period: 1,
          ),
        ),
      ),
    );

    expect(find.text('1º PERÍODO'), findsOneWidget);
    expect(find.text('Algoritmos e Lógica de Programação'), findsOneWidget);
    expect(find.text('Algo'), findsOneWidget);
  });
}
