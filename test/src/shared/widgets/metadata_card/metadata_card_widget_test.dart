import 'package:academic_planner/src/shared/widgets/metadata_card/metadata_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('MetadataCardWidget', () {
    testWidgets('renders both labels, formatted dates and icons', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          MetadataCardWidget(
            createdAt: DateTime(2024, 3, 5),
            updatedAt: DateTime(2024, 6, 21),
          ),
        ),
      );

      expect(find.text('Criado em'), findsOneWidget);
      expect(find.text('05/03/2024'), findsOneWidget);
      expect(find.text('Atualizado em'), findsOneWidget);
      expect(find.text('21/06/2024'), findsOneWidget);

      expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
      expect(find.byIcon(Icons.edit_note_rounded), findsOneWidget);
    });

    testWidgets('renders the same date for both fields when they match', (
      tester,
    ) async {
      final sameDate = DateTime(2024);

      await tester.pumpWidget(
        _harness(
          MetadataCardWidget(createdAt: sameDate, updatedAt: sameDate),
        ),
      );

      expect(find.text('01/01/2024'), findsNWidgets(2));
    });
  });
}
