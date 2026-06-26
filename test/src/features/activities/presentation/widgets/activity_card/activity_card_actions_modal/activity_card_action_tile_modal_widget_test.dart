import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_actions_modal/activity_card_action_tile_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ActivityCardActionTileModalWidget', () {
    testWidgets('renders the icon and the label', (tester) async {
      await tester.pumpWidget(
        _harness(
          ActivityCardActionTileModalWidget(
            icon: Icons.delete_outline_rounded,
            label: 'Excluir',
            onTap: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
      expect(find.text('Excluir'), findsOneWidget);
    });

    testWidgets('tapping the tile calls onTap', (tester) async {
      var tapCalls = 0;

      await tester.pumpWidget(
        _harness(
          ActivityCardActionTileModalWidget(
            icon: Icons.delete_outline_rounded,
            label: 'Excluir',
            onTap: () => tapCalls++,
          ),
        ),
      );

      await tester.tap(find.text('Excluir'));

      expect(tapCalls, 1);
    });
  });
}
