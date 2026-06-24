import 'package:academic_planner/src/shared/widgets/metadata_card/metadata_info_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: Row(children: [child])));
}

void main() {
  group('MetadataInfoRowWidget', () {
    testWidgets('renders the label, formatted date and icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          MetadataInfoRowWidget(
            label: 'Criado em',
            date: DateTime(2024, 3, 5),
            icon: Icons.calendar_today_rounded,
          ),
        ),
      );

      expect(find.text('Criado em'), findsOneWidget);
      expect(find.text('05/03/2024'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
    });

    testWidgets('formats a different date correctly', (tester) async {
      await tester.pumpWidget(
        _harness(
          MetadataInfoRowWidget(
            label: 'Atualizado em',
            date: DateTime(2023, 12, 31),
            icon: Icons.edit_note_rounded,
          ),
        ),
      );

      expect(find.text('31/12/2023'), findsOneWidget);
    });
  });
}
