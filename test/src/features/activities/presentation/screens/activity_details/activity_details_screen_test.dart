import 'dart:async';

import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_notifier.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/activity_details_screen.dart';
import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

class _FakeActivityNotifier extends ActivityNotifier {
  _FakeActivityNotifier({required this.onGetById, this.onEdit});

  final Future<Result<Activity?>> Function(String id) onGetById;
  final Future<Result<void>> Function(Activity activity)? onEdit;

  @override
  Future<void> build() async {}

  @override
  Future<Result<Activity?>> getById(String id) => onGetById(id);

  @override
  Future<Result<void>> edit(Activity activity) {
    if (onEdit != null) return onEdit!(activity);

    return Future.value(const Success<void>(null));
  }
}

Activity _activity({
  String id = 'a1',
  ActivityStatus status = ActivityStatus.pending,
  String? category,
  DateTime? dueDate,
  List<String> tags = const [],
  List<TimeOfDay> reminders = const [],
  String? notes,
}) => Activity(
  id: id,
  title: 'Prova de Calculo',
  description: 'Capitulos 1 a 3',
  disciplineId: 14,
  category: category,
  dueDate: dueDate,
  tags: tags,
  reminders: reminders,
  status: status,
  notes: notes,
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);

Future<ProviderContainer> _buildContainer({
  required Future<Result<Activity?>> Function(String id) onGetById,
  Future<Result<void>> Function(Activity activity)? onEdit,
}) async {
  final container = ProviderContainer(
    overrides: [
      activityNotifierProvider.overrideWith(
        () => _FakeActivityNotifier(onGetById: onGetById, onEdit: onEdit),
      ),
    ],
  );

  await container.read(activityNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container, String activityId) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(home: ActivityDetailsScreen(activityId: activityId)),
  );
}

void main() {
  const fluttertoastChannel = MethodChannel('PonnamKarthik/fluttertoast');

  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(fluttertoastChannel, (_) async => true);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(fluttertoastChannel, null);
  });

  group('ActivityDetailsScreen', () {
    testWidgets('fetch pending → shows the loading state', (tester) async {
      final completer = Completer<Result<Activity?>>();

      final container = await _buildContainer(
        onGetById: (_) => completer.future,
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container, 'a1'));
      await tester.pump();

      expect(find.byType(LoadingStateWidget), findsOneWidget);

      completer.complete(Success<Activity?>(_activity()));
      await tester.pumpAndSettle();
    });

    testWidgets('activity not found → shows the empty state', (
      tester,
    ) async {
      final container = await _buildContainer(
        onGetById: (_) async => const Success<Activity?>(null),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container, 'missing'));
      await tester.pumpAndSettle();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text('Atividade não encontrada'), findsOneWidget);
    });

    testWidgets('fetch failure → shows the empty state', (tester) async {
      final container = await _buildContainer(
        onGetById: (_) async =>
            const Failure<Activity?>(UnknownFailure('boom')),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container, 'a1'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });

    testWidgets('loaded activity → renders title, status and description', (
      tester,
    ) async {
      final container = await _buildContainer(
        onGetById: (_) async => Success<Activity?>(
          _activity(category: 'prova', tags: const ['urgente']),
        ),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container, 'a1'));
      await tester.pumpAndSettle();

      expect(find.text('Prova de Calculo'), findsWidgets);
      expect(find.text('PENDENTE'), findsOneWidget);
      expect(find.text('PROVA'), findsOneWidget);
      expect(find.text('#urgente'), findsOneWidget);
      expect(
        find.text('Capitulos 1 a 3', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets(
      'changing the status chip shows the save button; saving persists it',
      (tester) async {
        Activity? savedActivity;

        final container = await _buildContainer(
          onGetById: (_) async => Success<Activity?>(_activity()),
          onEdit: (activity) async {
            savedActivity = activity;

            return const Success<void>(null);
          },
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(_harness(container, 'a1'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.check_rounded), findsNothing);

        await tester.tap(find.text('Concluído'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.check_rounded), findsOneWidget);

        await tester.tap(find.byIcon(Icons.check_rounded));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 1));

        expect(savedActivity?.status, ActivityStatus.completed);
        expect(find.byIcon(Icons.check_rounded), findsNothing);
      },
    );
  });
}
