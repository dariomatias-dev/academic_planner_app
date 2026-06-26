import 'package:academic_planner/src/features/disciplines/di/discipline_providers.dart';
import 'package:academic_planner/src/features/disciplines/presentation/providers/user_disciplines_notifier.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_selection/discipline_selection_screen.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_selection/widgets/discipline_selection_period_selector_widget.dart';
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

Widget _harness(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(home: DisciplineSelectionScreen()),
  );
}

void main() {
  group('DisciplineSelectionScreen', () {
    testWidgets('renders the title and "Minha Grade" empty by default', (
      tester,
    ) async {
      final container = _buildContainer({});
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Configurar Grade'), findsOneWidget);
      expect(find.text('Minha Grade'), findsOneWidget);
      expect(find.text('Adicionar'), findsOneWidget);
      expect(find.text('Sua grade está vazia'), findsOneWidget);
    });

    testWidgets('switching to "Adicionar" shows the period selector', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = _buildContainer({});
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Adicionar'));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(DisciplineSelectionPeriodSelectorWidget),
          matching: find.text('1º Período'),
        ),
        findsOneWidget,
      );
      expect(find.text('Algoritmos e Lógica de Programação'), findsOneWidget);
    });

    testWidgets('disciplines selected → "Minha Grade" shows the summary', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = _buildContainer({14});
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Sua grade está vazia'), findsNothing);
      expect(find.text('Algoritmos e Lógica de Programação'), findsOneWidget);
    });
  });
}
