import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_notifier.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_actions_modal/activity_card_actions_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeActivityNotifier extends ActivityNotifier {
  _FakeActivityNotifier({this.onEdit});

  final Future<Result<void>> Function(Activity activity)? onEdit;

  @override
  Future<void> build() async {}

  @override
  Future<Result<void>> edit(Activity activity) {
    return onEdit?.call(activity) ?? Future.value(const Success<void>(null));
  }
}

Activity _activity({ActivityStatus status = ActivityStatus.pending}) =>
    Activity(
      id: 'a1',
      title: 'Prova de Calculo',
      description: 'desc',
      disciplineId: 14,
      tags: const [],
      reminders: const [],
      status: status,
      createdAt: DateTime(2025),
      updatedAt: DateTime(2025),
    );

Future<ProviderContainer> _buildContainer({
  Future<Result<void>> Function(Activity activity)? onEdit,
}) async {
  final container = ProviderContainer(
    overrides: [
      activityNotifierProvider.overrideWith(
        () => _FakeActivityNotifier(onEdit: onEdit),
      ),
    ],
  );

  await container.read(activityNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container, Activity activity) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                await showModalBottomSheet<void>(
                  context: context,
                  builder: (_) =>
                      ActivityCardActionsModalWidget(activity: activity),
                );
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    ),
  );
}

void main() {
  const fluttertoastChannel = MethodChannel('PonnamKarthik/fluttertoast');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(fluttertoastChannel, (_) async => true);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(fluttertoastChannel, null);
  });

  group('ActivityCardActionsModalWidget', () {
    testWidgets('pending activity → shows the "mark as completed" tile', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container, _activity()));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Prova de Calculo'), findsOneWidget);
      expect(find.text('Marcar como concluída'), findsOneWidget);
      expect(find.text('Editar informações'), findsOneWidget);
      expect(find.text('Excluir permanentemente'), findsOneWidget);
    });

    testWidgets(
      'completed activity → hides the "mark as completed" tile',
      (tester) async {
        final container = await _buildContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          _harness(container, _activity(status: ActivityStatus.completed)),
        );
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        expect(find.text('Marcar como concluída'), findsNothing);
      },
    );

    testWidgets(
      'marking as completed succeeds → edits the activity and closes the '
      'modal',
      (tester) async {
        Activity? editedActivity;

        final container = await _buildContainer(
          onEdit: (activity) async {
            editedActivity = activity;

            return const Success<void>(null);
          },
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(_harness(container, _activity()));
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Marcar como concluída'));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 1));

        expect(editedActivity?.status, ActivityStatus.completed);
        expect(find.text('Marcar como concluída'), findsNothing);
      },
    );

    testWidgets('tapping "Fechar" closes the modal', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container, _activity()));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();

      expect(find.text('AÇÕES DA ATIVIDADE'), findsNothing);
    });
  });
}
