import 'package:academic_planner/src/features/teacher/domain/entities/teacher.dart';
import 'package:academic_planner/src/features/teacher/presentation/screens/teacher_details/widgets/teacher_details_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('TeacherDetailsHeaderWidget', () {
    testWidgets('renders the initial, the name and the first degree badge', (
      tester,
    ) async {
      const teacher = Teacher(
        id: 1,
        name: 'Fernanda Costa Ribeiro',
        lattes: 'http://lattes.cnpq.br/123',
        academicBackground: [
          TeacherFormation(
            degree: 'Doutorado em Ciências da Computação',
            institution: 'UFPR',
            period: '2000 - 2002',
          ),
        ],
      );

      await tester.pumpWidget(
        _harness(const TeacherDetailsHeaderWidget(teacher: teacher)),
      );

      expect(find.text('F'), findsOneWidget);
      expect(find.text('Fernanda Costa Ribeiro'), findsOneWidget);
      expect(
        find.text('Doutorado em Ciências da Computação'),
        findsOneWidget,
      );
    });

    testWidgets('no academic background → hides the badge', (tester) async {
      const teacher = Teacher(
        id: 1,
        name: 'Fernanda Costa Ribeiro',
        lattes: 'http://lattes.cnpq.br/123',
      );

      await tester.pumpWidget(
        _harness(const TeacherDetailsHeaderWidget(teacher: teacher)),
      );

      expect(find.text('Fernanda Costa Ribeiro'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });
}
