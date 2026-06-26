import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/disciplines/disciplines_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness() {
  return const MaterialApp(home: DisciplinesScreen());
}

void main() {
  group('DisciplinesScreen', () {
    testWidgets('renders the title, subtitle and the schedule button', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_harness());
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Disciplinas'),
        ),
        findsOneWidget,
      );
      expect(
        find.text('Análise e Desenvolvimento de Sistemas'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.account_tree_rounded), findsOneWidget);
    });

    testWidgets('first tab → shows the period 1 summary and disciplines', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final period1Count = adsDisciplines.where((d) => d.period == 1).length;

      await tester.pumpWidget(_harness());
      await tester.pumpAndSettle();

      expect(find.text(period1Count.toString()), findsOneWidget);
      expect(find.text('Algoritmos e Lógica de Programação'), findsOneWidget);
    });

    testWidgets('switching to the period 2 tab shows its disciplines', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_harness());
      await tester.pumpAndSettle();

      await tester.tap(find.text('2º Período'));
      await tester.pumpAndSettle();

      expect(
        find.text('Programação Orientada a Objetos'),
        findsOneWidget,
      );
      expect(find.text('Algoritmos e Lógica de Programação'), findsNothing);
    });
  });
}
