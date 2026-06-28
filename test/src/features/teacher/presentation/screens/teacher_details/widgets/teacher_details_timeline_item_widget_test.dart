import 'package:academic_planner/src/features/teacher/presentation/screens/teacher_details/widgets/teacher_details_timeline_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TeacherDetailsTimelineItemWidget renders the title, '
      'subtitle and period', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TeacherDetailsTimelineItemWidget(
            title: 'Doutorado em Ciências da Computação',
            subtitle: 'Instituto Politécnico Aurora (IPA)',
            period: '2000 - 2002',
          ),
        ),
      ),
    );

    expect(
      find.text('Doutorado em Ciências da Computação'),
      findsOneWidget,
    );
    expect(find.text('Instituto Politécnico Aurora (IPA)'), findsOneWidget);
    expect(find.text('2000 - 2002'), findsOneWidget);
  });
}
