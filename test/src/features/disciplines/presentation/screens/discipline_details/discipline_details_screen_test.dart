import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_notifier.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/discipline_details_screen.dart';
import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/presentation/providers/note_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeActivityNotifier extends ActivityNotifier {
  @override
  Future<void> build() async {}

  @override
  Future<Result<List<Activity>>> getAll({
    ActivityFilter? filter,
    Pagination? pagination,
  }) async {
    return const Success<List<Activity>>([]);
  }
}

class _FakeNoteNotifier extends NoteNotifier {
  @override
  Future<void> build() async {}

  @override
  Future<Result<List<Note>>> getAll() async => const Success<List<Note>>([]);
}

Future<ProviderContainer> _buildContainer() async {
  final container = ProviderContainer(
    overrides: [
      activityNotifierProvider.overrideWith(_FakeActivityNotifier.new),
      noteNotifierProvider.overrideWith(_FakeNoteNotifier.new),
    ],
  );

  await container.read(activityNotifierProvider.future);
  await container.read(noteNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container, {int? initialTabIndex}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: DisciplineDetailsScreen(
        disciplineId: 14,
        initialTabIndex: initialTabIndex,
      ),
    ),
  );
}

void main() {
  group('DisciplineDetailsScreen', () {
    testWidgets('renders the header and the three tabs', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Algoritmos e Lógica de Programação'), findsOneWidget);
      expect(find.text('Tarefas'), findsOneWidget);
      expect(find.text('Anotações'), findsOneWidget);
      expect(find.text('Sobre'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('"Sobre" tab → hides the floating action button', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container, initialTabIndex: 2));
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.text('Sobre a Disciplina'), findsOneWidget);
    });

    testWidgets('"Anotações" tab → shows the notes empty state', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container, initialTabIndex: 1));
      await tester.pumpAndSettle();

      expect(find.text('Sem anotações'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('switching tabs updates the floating action button '
        'visibility', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);

      await tester.tap(find.text('Sobre'));
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsNothing);
    });
  });
}
