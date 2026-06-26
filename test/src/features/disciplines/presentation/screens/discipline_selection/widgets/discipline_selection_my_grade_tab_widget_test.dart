import 'package:academic_planner/src/features/disciplines/di/discipline_providers.dart';
import 'package:academic_planner/src/features/disciplines/presentation/providers/user_disciplines_notifier.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_selection/widgets/discipline_selection_my_grade_tab_widget.dart';
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
  group('DisciplineSelectionMyGradeTabWidget', () {
    testWidgets('no selected disciplines → shows the empty state', (
      tester,
    ) async {
      final container = _buildContainer({});
      addTearDown(container.dispose);

      final controller = TabController(length: 2, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          DisciplineSelectionMyGradeTabWidget(
            mainTabController: controller,
          ),
        ),
      );

      expect(find.text('Sua grade está vazia'), findsOneWidget);
      expect(find.text('Adicionar disciplinas'), findsOneWidget);
    });

    testWidgets('tapping "Adicionar disciplinas" switches to the "Add" tab', (
      tester,
    ) async {
      final container = _buildContainer({});
      addTearDown(container.dispose);

      final controller = TabController(length: 2, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          DisciplineSelectionMyGradeTabWidget(
            mainTabController: controller,
          ),
        ),
      );

      await tester.tap(find.text('Adicionar disciplinas'));
      await tester.pumpAndSettle();

      expect(controller.index, 1);
    });

    testWidgets('selected disciplines → renders the summary and the cards', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = _buildContainer({14});
      addTearDown(container.dispose);

      final controller = TabController(length: 2, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          DisciplineSelectionMyGradeTabWidget(
            mainTabController: controller,
          ),
        ),
      );

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Algoritmos e Lógica de Programação'), findsOneWidget);
      expect(
        find.byIcon(Icons.remove_circle_outline_rounded),
        findsOneWidget,
      );
    });

    testWidgets('tapping a card toggles the discipline off', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = _buildContainer({14});
      addTearDown(container.dispose);

      final controller = TabController(length: 2, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          DisciplineSelectionMyGradeTabWidget(
            mainTabController: controller,
          ),
        ),
      );

      await tester.tap(find.text('Algoritmos e Lógica de Programação'));
      await tester.pumpAndSettle();

      expect(container.read(userDisciplinesNotifierProvider), isEmpty);
      expect(find.text('Sua grade está vazia'), findsOneWidget);
    });
  });
}
