import 'package:academic_planner/src/features/disciplines/di/discipline_providers.dart';
import 'package:academic_planner/src/features/disciplines/presentation/providers/user_disciplines_notifier.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/my_disciplines/my_disciplines_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeUserDisciplinesNotifier extends UserDisciplinesNotifier {
  _FakeUserDisciplinesNotifier(this._initial);

  final Set<int> _initial;

  @override
  Set<int> build() => Set<int>.from(_initial);
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
    child: const MaterialApp(home: MyDisciplinesScreen()),
  );
}

void main() {
  group('MyDisciplinesScreen', () {
    testWidgets('no disciplines selected → shows the empty state', (
      tester,
    ) async {
      final container = _buildContainer({});
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Minha Grade'), findsOneWidget);
      expect(find.text('Sua grade está vazia'), findsOneWidget);
    });

    testWidgets('disciplines selected → shows the summary and the cards', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = _buildContainer({14});
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Sua grade está vazia'), findsNothing);
      expect(find.text('Algoritmos e Lógica de Programação'), findsOneWidget);
    });

    testWidgets('renders the schedule and add discipline buttons', (
      tester,
    ) async {
      final container = _buildContainer({});
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.account_tree_rounded), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
    });
  });
}
