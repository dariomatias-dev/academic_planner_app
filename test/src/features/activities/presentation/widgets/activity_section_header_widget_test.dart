import 'package:academic_planner/src/features/activities/presentation/widgets/activity_section_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ActivitySectionHeaderWidget', () {
    testWidgets('renders the title in upper case', (tester) async {
      await tester.pumpWidget(
        _harness(const ActivitySectionHeaderWidget(title: 'pendentes')),
      );

      expect(find.text('PENDENTES'), findsOneWidget);
    });

    testWidgets('no action provided → renders no extra trailing widget', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(const ActivitySectionHeaderWidget(title: 'pendentes')),
      );

      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('action provided → renders it', (tester) async {
      await tester.pumpWidget(
        _harness(
          ActivitySectionHeaderWidget(
            title: 'pendentes',
            action: IconButton(icon: const Icon(Icons.add), onPressed: () {}),
          ),
        ),
      );

      expect(find.byType(IconButton), findsOneWidget);
    });
  });
}
