import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/features/disciplines/presentation/widgets/discipline_card/discipline_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('DisciplineCardWidget', () {
    testWidgets('renders acronym, name, period and teacher name', (
      tester,
    ) async {
      final discipline = adsDisciplines.firstWhere((d) => d.id == 14);

      await tester.pumpWidget(
        _harness(DisciplineCardWidget(index: 1, discipline: discipline)),
      );

      expect(find.text('Algo'), findsOneWidget);
      expect(find.text('Algoritmos e Lógica de Programação'), findsOneWidget);
      expect(find.text('1º Período'), findsOneWidget);
      expect(find.text('Fernanda Costa Ribeiro'), findsOneWidget);
      expect(find.text('01'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios_rounded), findsOneWidget);
    });

    testWidgets('trailing provided → replaces the default arrow icon', (
      tester,
    ) async {
      final discipline = adsDisciplines.firstWhere((d) => d.id == 14);

      await tester.pumpWidget(
        _harness(
          DisciplineCardWidget(
            index: 1,
            discipline: discipline,
            trailing: const Icon(Icons.check_circle_rounded),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward_ios_rounded), findsNothing);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('tapping the card calls onTap', (tester) async {
      final discipline = adsDisciplines.firstWhere((d) => d.id == 14);
      var tapCalls = 0;

      await tester.pumpWidget(
        _harness(
          DisciplineCardWidget(
            index: 1,
            discipline: discipline,
            onTap: () => tapCalls++,
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));

      expect(tapCalls, 1);
    });
  });
}
