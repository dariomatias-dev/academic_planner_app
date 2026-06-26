import 'package:academic_planner/src/shared/widgets/forms/form_field_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('FormFieldLabelWidget', () {
    testWidgets('renders the label without an asterisk by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(const FormFieldLabelWidget(label: 'Nome')),
      );

      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('Nome *'), findsNothing);
    });

    testWidgets('isRequired true → appends a red asterisk', (tester) async {
      await tester.pumpWidget(
        _harness(
          const FormFieldLabelWidget(label: 'Nome', isRequired: true),
        ),
      );

      expect(find.text('Nome *'), findsOneWidget);

      final text = tester.widget<Text>(find.text('Nome *'));
      final rootSpan = text.textSpan! as TextSpan;
      final asteriskSpan = rootSpan.children!.single as TextSpan;

      expect(asteriskSpan.style?.color, Colors.red);
    });

    testWidgets('forwards fontSize to the label style', (tester) async {
      await tester.pumpWidget(
        _harness(const FormFieldLabelWidget(label: 'Nome', fontSize: 20.0)),
      );

      final text = tester.widget<Text>(find.text('Nome'));

      expect(text.textSpan!.style?.fontSize, 20.0);
    });
  });
}
