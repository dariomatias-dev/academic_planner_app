import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_requirement_expandable_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('DisciplineDetailsRequirementExpandableTileWidget', () {
    testWidgets('no linked disciplines → shows zero count and no chevron', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const DisciplineDetailsRequirementExpandableTileWidget(
            label: 'Pré-requisitos',
            linkedDisciplines: [],
            color: Colors.blue,
          ),
        ),
      );

      expect(find.text('Pré-requisitos'), findsOneWidget);
      expect(find.text('0 Disciplinas'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
    });

    testWidgets('tapping with no linked disciplines does nothing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const DisciplineDetailsRequirementExpandableTileWidget(
            label: 'Pré-requisitos',
            linkedDisciplines: [],
            color: Colors.blue,
          ),
        ),
      );

      await tester.tap(find.text('Pré-requisitos'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('linked disciplines → tapping expands and reveals the '
        'cards', (tester) async {
      final linked = adsDisciplines.where((d) => d.id == 14).toList();

      await tester.pumpWidget(
        _harness(
          DisciplineDetailsRequirementExpandableTileWidget(
            label: 'Pré-requisitos',
            linkedDisciplines: linked,
            color: Colors.blue,
          ),
        ),
      );

      expect(find.text('1 Disciplinas'), findsOneWidget);

      await tester.tap(find.text('Pré-requisitos'));
      await tester.pumpAndSettle();

      expect(find.text('Algoritmos e Lógica de Programação'), findsOneWidget);
    });
  });
}
