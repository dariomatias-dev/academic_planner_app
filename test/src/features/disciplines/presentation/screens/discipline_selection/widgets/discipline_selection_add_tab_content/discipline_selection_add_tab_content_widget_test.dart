import 'package:academic_planner/src/features/disciplines/di/discipline_providers.dart';
import 'package:academic_planner/src/features/disciplines/presentation/providers/user_disciplines_notifier.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_selection/widgets/discipline_selection_add_tab_content/discipline_selection_add_tab_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeUserDisciplinesNotifier extends UserDisciplinesNotifier {
  _FakeUserDisciplinesNotifier(this._initial);

  final Set<int> _initial;

  @override
  Set<int> build() => Set<int>.from(_initial);

  @override
  Future<void> toggleDiscipline(int id) async {
    final newSet = Set<int>.from(state);

    if (newSet.contains(id)) {
      newSet.remove(id);
    } else {
      newSet.add(id);
    }

    state = newSet;
  }
}

ProviderContainer _buildContainer(Set<int> initialSelected) {
  return ProviderContainer(
    overrides: [
      userDisciplinesNotifierProvider.overrideWith(
        () => _FakeUserDisciplinesNotifier(initialSelected),
      ),
    ],
  );
}

Widget _harness(ProviderContainer container, Widget child) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('DisciplineSelectionAddTabContentWidget conflict detection', () {
    testWidgets(
      'day boundary index=5 (Sexta-feira) → partial overlap shows '
      'only the colliding slots, in schedule order',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final container = _buildContainer({14});
        addTearDown(container.dispose);

        final controller = TabController(
          length: 2,
          vsync: tester,
          initialIndex: 1,
        );
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _harness(
            container,
            DisciplineSelectionAddTabContentWidget(
              periods: const [1, 3],
              periodController: controller,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Padrões de Projeto'));
        await tester.pumpAndSettle();

        expect(find.text('Conflito de Horário'), findsOneWidget);
        expect(
          find.text(
            "Não foi possível adicionar 'Padrões de Projeto' devido aos "
            'seguintes conflitos:\n\n'
            '• Sexta-feira às 13:20: Algoritmos e Lógica de Programação\n'
            '• Sexta-feira às 14:10: Algoritmos e Lógica de Programação',
          ),
          findsOneWidget,
        );

        expect(container.read(userDisciplinesNotifierProvider), {14});
      },
    );

    testWidgets(
      'full overlap on day=4 (Quinta-feira) → one bullet per colliding '
      'slot, none dropped by dedup',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final container = _buildContainer({14});
        addTearDown(container.dispose);

        final controller = TabController(
          length: 2,
          vsync: tester,
          initialIndex: 1,
        );
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _harness(
            container,
            DisciplineSelectionAddTabContentWidget(
              periods: const [1, 2],
              periodController: controller,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Introdução a Redes de Computadores'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Conflito de Horário'), findsOneWidget);
        expect(
          find.text(
            "Não foi possível adicionar 'Introdução a Redes de "
            "Computadores' devido aos seguintes conflitos:\n\n"
            '• Quinta-feira às 8:40: Algoritmos e Lógica de Programação\n'
            '• Quinta-feira às 9:50: Algoritmos e Lógica de Programação\n'
            '• Quinta-feira às 10:40: Algoritmos e Lógica de Programação\n'
            '• Quinta-feira às 11:30: Algoritmos e Lógica de Programação',
          ),
          findsOneWidget,
        );

        expect(container.read(userDisciplinesNotifierProvider), {14});
      },
    );

    testWidgets(
      'no overlapping slots → adds the discipline directly without '
      'showing the conflict dialog',
      (tester) async {
        final container = _buildContainer({14});
        addTearDown(container.dispose);

        final controller = TabController(length: 1, vsync: tester);
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _harness(
            container,
            DisciplineSelectionAddTabContentWidget(
              periods: const [1],
              periodController: controller,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Introdução à Computação'));
        await tester.pumpAndSettle();

        expect(find.text('Conflito de Horário'), findsNothing);
        expect(container.read(userDisciplinesNotifierProvider), {14, 15});
      },
    );

    testWidgets(
      'tapping an already-selected discipline removes it directly, '
      'skipping the conflict check entirely',
      (tester) async {
        final container = _buildContainer({14, 26});
        addTearDown(container.dispose);

        final controller = TabController(length: 2, vsync: tester);
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _harness(
            container,
            DisciplineSelectionAddTabContentWidget(
              periods: const [1, 2],
              periodController: controller,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Algoritmos e Lógica de Programação'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Conflito de Horário'), findsNothing);
        expect(container.read(userDisciplinesNotifierProvider), {26});
      },
    );
  });
}
