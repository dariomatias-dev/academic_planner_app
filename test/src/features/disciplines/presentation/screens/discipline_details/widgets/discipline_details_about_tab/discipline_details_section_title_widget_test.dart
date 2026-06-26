import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DisciplineDetailsSectionTitleWidget renders the icon and '
      'the title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DisciplineDetailsSectionTitleWidget(
            title: 'Sobre a Disciplina',
            icon: Icons.description_outlined,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.description_outlined), findsOneWidget);
    expect(find.text('Sobre a Disciplina'), findsOneWidget);
  });
}
