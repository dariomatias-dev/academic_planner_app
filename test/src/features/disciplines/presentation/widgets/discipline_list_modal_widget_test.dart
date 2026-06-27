import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/domain/entities/discipline.dart';
import 'package:academic_planner/src/features/disciplines/presentation/widgets/discipline_list_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

List<Discipline> _disciplines() =>
    adsDisciplines.where((d) => d.id == 14 || d.id == 15).toList();

void main() {
  group('DisciplineListModalWidget', () {
    testWidgets('no disciplines → shows the default empty state', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          DisciplineListModalWidget(disciplines: const [], onSelected: (_) {}),
        ),
      );

      expect(find.text('Nenhuma disciplina'), findsOneWidget);
      expect(
        find.text('Não encontramos disciplinas cadastradas.'),
        findsOneWidget,
      );
    });

    testWidgets('no disciplines → custom empty title and description', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          DisciplineListModalWidget(
            disciplines: const [],
            onSelected: (_) {},
            emptyTitle: 'Vazio',
            emptyDescription: 'Sem nada aqui',
          ),
        ),
      );

      expect(find.text('Vazio'), findsOneWidget);
      expect(find.text('Sem nada aqui'), findsOneWidget);
    });

    testWidgets('renders one tile per discipline', (tester) async {
      await tester.pumpWidget(
        _harness(
          DisciplineListModalWidget(
            disciplines: _disciplines(),
            onSelected: (_) {},
          ),
        ),
      );

      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('Algoritmos e Lógica de Programação'), findsOneWidget);
    });

    testWidgets('selected discipline → shows the check icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          DisciplineListModalWidget(
            disciplines: _disciplines(),
            selectedId: 14,
            onSelected: (_) {},
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(find.byIcon(Icons.circle_outlined), findsOneWidget);
    });

    testWidgets('tapping a tile calls onSelected and pops', (tester) async {
      Discipline? selected;

      await tester.pumpWidget(
        _harness(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => DisciplineListModalWidget(
                      disciplines: _disciplines(),
                      onSelected: (value) => selected = value,
                    ),
                  );
                },
                child: const Text('open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Algoritmos e Lógica de Programação'));
      await tester.pumpAndSettle();

      expect(selected?.id, 14);
      expect(find.byType(ListTile), findsNothing);
    });
  });
}
