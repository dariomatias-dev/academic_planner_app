import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity_stats.dart';
import 'package:academic_planner/src/features/activities/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/activities/presentation/actions/delete_activity_flow.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_stats_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

class _FakeActivityStatsNotifier extends ActivityStatsNotifier {
  int refreshCalls = 0;

  @override
  Future<ActivityStats> build() async {
    return const ActivityStats(
      total: 0,
      active: 0,
      completed: 0,
      urgent: 0,
      progress: 0,
    );
  }

  @override
  Future<void> refresh() async {
    refreshCalls++;
  }
}

final Activity _activity = Activity(
  id: '1',
  title: 'Cálculo I',
  description: 'Description',
  disciplineId: 1,
  tags: const [],
  reminders: const [],
  status: ActivityStatus.pending,
);

Widget _harness(
  Future<void> Function(BuildContext context, WidgetRef ref) onPressed,
) {
  return MaterialApp(
    home: Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          return ElevatedButton(
            onPressed: () => onPressed(context, ref),
            child: const Text('trigger'),
          );
        },
      ),
    ),
  );
}

void main() {
  late MockActivityRepository mockRepository;
  late _FakeActivityStatsNotifier fakeStatsNotifier;
  late ProviderContainer container;

  setUp(() async {
    mockRepository = MockActivityRepository();
    fakeStatsNotifier = _FakeActivityStatsNotifier();
    container = ProviderContainer(
      overrides: [
        activityRepositoryProvider.overrideWithValue(mockRepository),
        activityStatsNotifierProvider.overrideWith(() => fakeStatsNotifier),
      ],
    );

    addTearDown(container.dispose);

    container.read(activityNotifierProvider.notifier);

    await container.read(activityNotifierProvider.future);
  });

  testWidgets(
    'shows the confirm dialog with the activity title interpolated',
    (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _harness(
            (context, ref) {
              return deleteActivityFlow(
                context: context,
                ref: ref,
                activity: _activity,
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir Atividade'), findsOneWidget);
      expect(
        find.text(
          "Tem certeza que deseja excluir 'Cálculo I'? "
          'Esta ação não poderá ser desfeita.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('cancel → does not call delete and returns false', (
    tester,
  ) async {
    bool? result;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: _harness((context, ref) async {
          result = await deleteActivityFlow(
            context: context,
            ref: ref,
            activity: _activity,
          );
        }),
      ),
    );

    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    verifyNever(() => mockRepository.delete(any()));

    expect(result, isFalse);
  });

  testWidgets(
    'confirm success → deletes by id, shows success dialog and returns true',
    (tester) async {
      when(
        () => mockRepository.delete('1'),
      ).thenAnswer((_) async => const Success<void>(null));

      bool? result;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _harness((context, ref) async {
            result = await deleteActivityFlow(
              context: context,
              ref: ref,
              activity: _activity,
            );
          }),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Excluir'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Atividade Removida'), findsOneWidget);
      expect(
        find.text(
          'A atividade foi excluída com sucesso do seu cronograma acadêmico.',
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();

      verify(() => mockRepository.delete('1')).called(1);

      expect(result, isTrue);
    },
  );

  testWidgets(
    'confirm failure → shows the failure dialog with the error message',
    (tester) async {
      when(
        () => mockRepository.delete('1'),
      ).thenAnswer((_) async => const Failure<void>(UnknownFailure('boom')));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _harness(
            (context, ref) {
              return deleteActivityFlow(
                context: context,
                ref: ref,
                activity: _activity,
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Excluir'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.text(
          'Não conseguimos remover a atividade no momento.'
          ' Por favor, tente novamente em instantes.',
        ),
        findsOneWidget,
      );
      expect(find.text('boom'), findsOneWidget);
    },
  );
}
