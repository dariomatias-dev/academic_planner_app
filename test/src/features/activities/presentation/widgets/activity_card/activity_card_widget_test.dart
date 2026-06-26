import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Activity _activity({
  ActivityStatus status = ActivityStatus.pending,
  String? category,
  DateTime? dueDate,
}) => Activity(
  id: 'a1',
  title: 'Prova de Calculo',
  description: 'desc',
  disciplineId: 14,
  category: category,
  dueDate: dueDate,
  tags: const [],
  reminders: const [],
  status: status,
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);

Widget _harness(Widget child) {
  return ProviderScope(
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('ActivityCardWidget', () {
    testWidgets('renders the discipline acronym and the title', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(ActivityCardWidget(activity: _activity())),
      );

      expect(find.text('Algo'), findsOneWidget);
      expect(find.text('Prova de Calculo'), findsOneWidget);
    });

    testWidgets('no category → does not render a category badge', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(ActivityCardWidget(activity: _activity())),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.textContaining('PROVA'), findsNothing);
    });

    testWidgets('category set → renders it upper-cased', (tester) async {
      await tester.pumpWidget(
        _harness(
          ActivityCardWidget(activity: _activity(category: 'prova')),
        ),
      );

      expect(find.text('PROVA'), findsOneWidget);
    });

    testWidgets('due date close to today and not completed → shows the '
        'urgent icon', (tester) async {
      await tester.pumpWidget(
        _harness(
          ActivityCardWidget(
            activity: _activity(
              dueDate: DateTime.now().add(const Duration(days: 1)),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.priority_high_rounded), findsOneWidget);
    });

    testWidgets('completed status → never shows the urgent icon even with '
        'a near due date', (tester) async {
      await tester.pumpWidget(
        _harness(
          ActivityCardWidget(
            activity: _activity(
              status: ActivityStatus.completed,
              dueDate: DateTime.now().add(const Duration(days: 1)),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.priority_high_rounded), findsNothing);
    });

    testWidgets('far due date → does not show the urgent icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          ActivityCardWidget(
            activity: _activity(
              dueDate: DateTime.now().add(const Duration(days: 30)),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.priority_high_rounded), findsNothing);
    });

    testWidgets('long press opens the actions modal', (tester) async {
      await tester.pumpWidget(
        _harness(ActivityCardWidget(activity: _activity())),
      );

      await tester.longPress(find.text('Prova de Calculo'));
      await tester.pumpAndSettle();

      expect(find.text('AÇÕES DA ATIVIDADE'), findsOneWidget);
    });
  });
}
