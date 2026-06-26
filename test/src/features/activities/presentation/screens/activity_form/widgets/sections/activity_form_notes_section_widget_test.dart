import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/sections/activity_form_notes_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ActivityFormNotesSectionWidget', () {
    testWidgets('renders the section title and the hint', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(ActivityFormNotesSectionWidget(controller: controller)),
      );

      expect(find.text('Anotações'), findsOneWidget);
      expect(find.text('Rascunhos ou lembretes rápidos...'), findsOneWidget);
    });

    testWidgets('typing updates the controller text', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(ActivityFormNotesSectionWidget(controller: controller)),
      );

      await tester.enterText(find.byType(TextFormField), 'Levar calculadora');

      expect(controller.text, 'Levar calculadora');
    });
  });
}
