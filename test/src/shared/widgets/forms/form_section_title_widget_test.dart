import 'package:academic_planner/src/shared/widgets/forms/form_section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('FormSectionTitleWidget', () {
    testWidgets('renders the title', (tester) async {
      await tester.pumpWidget(
        _harness(const FormSectionTitleWidget(title: 'Detalhes')),
      );

      expect(find.text('Detalhes'), findsOneWidget);
    });

    testWidgets('default padding → bottom: 12.0', (tester) async {
      await tester.pumpWidget(
        _harness(const FormSectionTitleWidget(title: 'Detalhes')),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));

      expect(padding.padding, const EdgeInsets.only(bottom: 12.0));
    });

    testWidgets('custom padding is forwarded', (tester) async {
      const customPadding = EdgeInsets.all(8.0);

      await tester.pumpWidget(
        _harness(
          const FormSectionTitleWidget(
            title: 'Detalhes',
            padding: customPadding,
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));

      expect(padding.padding, customPadding);
    });
  });
}
