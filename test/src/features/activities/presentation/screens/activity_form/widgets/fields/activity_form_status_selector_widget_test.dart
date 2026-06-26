import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/activity_form_status_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ActivityFormStatusSelectorWidget', () {
    testWidgets('renders a chip for every ActivityStatus', (tester) async {
      await tester.pumpWidget(
        _harness(
          ActivityFormStatusSelectorWidget(
            selectedStatus: ActivityStatus.pending,
            onSelect: (_) {},
          ),
        ),
      );

      expect(find.text('Rascunho'), findsOneWidget);
      expect(find.text('Pendente'), findsOneWidget);
      expect(find.text('Em Andamento'), findsOneWidget);
      expect(find.text('Concluído'), findsOneWidget);
      expect(find.text('Cancelado'), findsOneWidget);
    });

    testWidgets('tapping a status calls onSelect with that status', (
      tester,
    ) async {
      ActivityStatus? selected;

      await tester.pumpWidget(
        _harness(
          ActivityFormStatusSelectorWidget(
            selectedStatus: ActivityStatus.pending,
            onSelect: (value) => selected = value,
          ),
        ),
      );

      await tester.tap(find.text('Concluído'));

      expect(selected, ActivityStatus.completed);
    });
  });
}
