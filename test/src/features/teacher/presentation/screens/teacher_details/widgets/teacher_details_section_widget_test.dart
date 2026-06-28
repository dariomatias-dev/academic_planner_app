import 'package:academic_planner/src/features/teacher/presentation/screens/teacher_details/widgets/teacher_details_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TeacherDetailsSectionWidget renders the upper-cased title '
      'and the content', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TeacherDetailsSectionWidget(
            title: 'formação acadêmica',
            content: Text('conteúdo da seção'),
          ),
        ),
      ),
    );

    expect(find.text('FORMAÇÃO ACADÊMICA'), findsOneWidget);
    expect(find.text('conteúdo da seção'), findsOneWidget);
  });
}
