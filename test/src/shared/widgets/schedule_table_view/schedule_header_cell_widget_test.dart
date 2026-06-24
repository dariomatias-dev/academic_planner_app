import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_header_cell_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme,
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('ScheduleHeaderCellWidget', () {
    testWidgets('renders the text in uppercase', (tester) async {
      await tester.pumpWidget(
        _harness(const ScheduleHeaderCellWidget(text: 'segunda-feira')),
      );

      expect(find.text('SEGUNDA-FEIRA'), findsOneWidget);
      expect(find.text('segunda-feira'), findsNothing);
    });

    testWidgets('no dividerTheme color → falls back to a transparent border', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(const ScheduleHeaderCellWidget(text: 'Hora')),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      final border = decoration.border! as Border;

      expect(border.right.color, AppColors.transparent);
      expect(border.bottom.color, AppColors.transparent);
    });

    testWidgets('dividerTheme color is forwarded to the border', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const ScheduleHeaderCellWidget(text: 'Hora'),
          theme: ThemeData(
            dividerTheme: const DividerThemeData(color: Colors.grey),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      final border = decoration.border! as Border;

      expect(border.right.color, Colors.grey);
      expect(border.bottom.color, Colors.grey);
    });
  });
}
