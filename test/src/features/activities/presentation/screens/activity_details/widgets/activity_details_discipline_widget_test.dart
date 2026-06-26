import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_discipline_widget.dart';
import 'package:academic_planner/src/features/disciplines/domain/entities/discipline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

Discipline _discipline() => adsDisciplines.firstWhere((d) => d.id == 14);

void main() {
  group('ActivityDetailsDisciplineWidget', () {
    testWidgets('renders the acronym, name and period', (tester) async {
      await tester.pumpWidget(
        _harness(ActivityDetailsDisciplineWidget(discipline: _discipline())),
      );

      expect(find.text('Algo'), findsOneWidget);
      expect(find.text('Algoritmos e Lógica de Programação'), findsOneWidget);
      expect(find.text('1º Período'), findsOneWidget);
    });
  });
}
