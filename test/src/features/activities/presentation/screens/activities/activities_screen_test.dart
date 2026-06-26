import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_notifier.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activities/activities_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  @override
  Future<Result<int>> count({ActivityFilter? filter}) async {
    return const Success<int>(0);
  }
}

Future<ProviderContainer> _buildContainer() async {
  final container = ProviderContainer(
    overrides: [
      activityNotifierProvider.overrideWith(_FakeActivityNotifier.new),
    ],
  );

  await container.read(activityNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(home: ActivitiesScreen()),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  group('ActivitiesScreen', () {
    testWidgets('renders the search field and the four tabs', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Resumo'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Ativas'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Concluídas'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Outras'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('typing in the search field updates the activity filter', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'calculo');
      await tester.pumpAndSettle();

      expect(
        container.read(activityFilterNotifierProvider).search,
        'calculo',
      );
    });

    testWidgets('tapping the "Concluídas" tab shows its description', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(Tab, 'Concluídas'));
      await tester.pumpAndSettle();

      expect(
        find.text('Histórico de Atividades Finalizadas'),
        findsOneWidget,
      );
    });

    testWidgets(
      'setting a "completed" filter externally switches to the '
      '"Concluídas" tab',
      (tester) async {
        final container = await _buildContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(_harness(container));
        await tester.pumpAndSettle();

        container.read(activityFilterNotifierProvider.notifier).filter =
            const ActivityFilter(statuses: [ActivityStatus.completed]);
        await tester.pumpAndSettle();

        expect(
          find.text('Histórico de Atividades Finalizadas'),
          findsOneWidget,
        );
      },
    );
  });
}
