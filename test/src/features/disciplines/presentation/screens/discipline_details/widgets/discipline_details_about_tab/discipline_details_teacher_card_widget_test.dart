import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_teacher_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DisciplineDetailsTeacherCardWidget', () {
    testWidgets('renders the teacher name and the subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DisciplineDetailsTeacherCardWidget(
              teacherName: 'Fernanda Costa Ribeiro',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Fernanda Costa Ribeiro'), findsOneWidget);
      expect(find.text('Ver perfil do professor'), findsOneWidget);
    });

    testWidgets('tapping the card calls onTap', (tester) async {
      var tapCalls = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DisciplineDetailsTeacherCardWidget(
              teacherName: 'Fernanda Costa Ribeiro',
              onTap: () => tapCalls++,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));

      expect(tapCalls, 1);
    });
  });
}
