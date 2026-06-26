import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_selection/widgets/discipline_selection_add_tab_content/discipline_selection_check_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('DisciplineSelectionCheckIconWidget', () {
    testWidgets('not selected → renders no check icon', (tester) async {
      await tester.pumpWidget(
        _harness(const DisciplineSelectionCheckIconWidget(isSelected: false)),
      );

      expect(find.byIcon(Icons.check_rounded), findsNothing);
    });

    testWidgets('selected → renders the check icon', (tester) async {
      await tester.pumpWidget(
        _harness(const DisciplineSelectionCheckIconWidget(isSelected: true)),
      );

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });
  });
}
