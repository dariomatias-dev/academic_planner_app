import 'package:academic_planner/src/features/activities/presentation/screens/activities/widgets/activities_total_badge_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ActivitiesTotalBadgeWidget', () {
    testWidgets('renders the title and subtitle', (tester) async {
      await tester.pumpWidget(
        _harness(
          const ActivitiesTotalBadgeWidget(
            state: AsyncData<int>(5),
            title: 'Minhas Atividades',
            subtitle: 'Total acumulado',
          ),
        ),
      );

      expect(find.text('Minhas Atividades'), findsOneWidget);
      expect(find.text('Total acumulado'), findsOneWidget);
    });

    testWidgets('data → shows the count', (tester) async {
      await tester.pumpWidget(
        _harness(
          const ActivitiesTotalBadgeWidget(
            state: AsyncData<int>(12),
            title: 'Minhas Atividades',
            subtitle: 'Total acumulado',
          ),
        ),
      );

      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('loading → shows a progress indicator instead of a count', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const ActivitiesTotalBadgeWidget(
            state: AsyncLoading<int>(),
            title: 'Minhas Atividades',
            subtitle: 'Total acumulado',
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('error → renders nothing in place of the count', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const ActivitiesTotalBadgeWidget(
            state: AsyncError<int>('fail', StackTrace.empty),
            title: 'Minhas Atividades',
            subtitle: 'Total acumulado',
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.collections_bookmark_rounded), findsNothing);
    });
  });
}
