import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/sections/activity_form_content_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      FlutterQuillLocalizations.delegate,
    ],
    home: Scaffold(body: child),
  );
}

void main() {
  group('ActivityFormContentSectionWidget', () {
    testWidgets('renders the title field and the description editor', (
      tester,
    ) async {
      final titleController = TextEditingController();
      final descriptionController = QuillController.basic();
      addTearDown(titleController.dispose);
      addTearDown(descriptionController.dispose);

      await tester.pumpWidget(
        _harness(
          ActivityFormContentSectionWidget(
            titleController: titleController,
            descriptionController: descriptionController,
          ),
        ),
      );
      await tester.pump(Duration.zero);

      expect(find.text('Conteúdo'), findsOneWidget);
      expect(find.text('Título *'), findsOneWidget);
      expect(find.text('Descrição *'), findsOneWidget);
    });

    testWidgets('typing in the title field updates its controller', (
      tester,
    ) async {
      final titleController = TextEditingController();
      final descriptionController = QuillController.basic();
      addTearDown(titleController.dispose);
      addTearDown(descriptionController.dispose);

      await tester.pumpWidget(
        _harness(
          ActivityFormContentSectionWidget(
            titleController: titleController,
            descriptionController: descriptionController,
          ),
        ),
      );
      await tester.pump(Duration.zero);

      await tester.enterText(find.byType(TextFormField), 'Prova de Calculo');

      expect(titleController.text, 'Prova de Calculo');
    });
  });
}
