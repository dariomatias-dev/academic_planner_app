import 'package:academic_planner/src/shared/widgets/forms/input_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child, {GlobalKey<FormState>? formKey}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: formKey != null ? Form(key: formKey, child: child) : child,
      ),
    ),
  );
}

void main() {
  group('InputFieldWidget', () {
    testWidgets('renders the label', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        _harness(
          InputFieldWidget(
            controller: controller,
            label: 'Nome',
            hint: 'Digite seu nome',
          ),
        ),
      );

      expect(find.text('Nome'), findsOneWidget);
    });

    testWidgets('isRequired → appends asterisk to the label', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        _harness(
          InputFieldWidget(
            controller: controller,
            label: 'Nome',
            hint: 'Digite seu nome',
            isRequired: true,
          ),
        ),
      );

      expect(find.text('Nome'), findsNothing);
      expect(find.text('Nome *'), findsOneWidget);
    });

    testWidgets('renders the hint as placeholder text', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        _harness(
          InputFieldWidget(
            controller: controller,
            label: 'Nome',
            hint: 'Digite seu nome',
          ),
        ),
      );

      expect(find.text('Digite seu nome'), findsOneWidget);
    });

    testWidgets('typing updates the controller', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        _harness(
          InputFieldWidget(
            controller: controller,
            label: 'Nome',
            hint: 'Digite seu nome',
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Maria');

      expect(controller.text, 'Maria');
    });

    testWidgets('forwards maxLines to the underlying field', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        _harness(
          InputFieldWidget(
            controller: controller,
            label: 'Descrição',
            hint: 'Digite a descrição',
            maxLines: 4,
          ),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));

      expect(field.maxLines, 4);
    });

    testWidgets('validator runs on form validation and shows the error', (
      tester,
    ) async {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        _harness(
          formKey: formKey,
          InputFieldWidget(
            controller: controller,
            label: 'Nome',
            hint: 'Digite seu nome',
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);
    });
  });
}
