import 'package:academic_planner/src/shared/widgets/forms/rich_text_field/rich_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child, {GlobalKey<FormState>? formKey}) {
  return MaterialApp(
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      FlutterQuillLocalizations.delegate,
    ],
    home: Scaffold(
      body: formKey != null ? Form(key: formKey, child: child) : child,
    ),
  );
}

void main() {
  group('RichTextFieldWidget', () {
    testWidgets('renders the label without an asterisk by default', (
      tester,
    ) async {
      final controller = QuillController.basic();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          RichTextFieldWidget(
            controller: controller,
            label: 'Descrição',
            placeholder: 'Escreva algo',
          ),
        ),
      );
      await tester.pump(Duration.zero);

      expect(find.text('Descrição'), findsOneWidget);
    });

    testWidgets('validatorMessage set → appends asterisk to the label', (
      tester,
    ) async {
      final controller = QuillController.basic();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          RichTextFieldWidget(
            controller: controller,
            label: 'Descrição',
            placeholder: 'Escreva algo',
            validatorMessage: 'Campo obrigatório',
          ),
        ),
      );
      await tester.pump(Duration.zero);

      expect(find.text('Descrição'), findsNothing);
      expect(find.text('Descrição *'), findsOneWidget);
    });

    testWidgets('no validatorMessage → form validation never shows an error', (
      tester,
    ) async {
      final controller = QuillController.basic();
      addTearDown(controller.dispose);
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        _harness(
          formKey: formKey,
          RichTextFieldWidget(
            controller: controller,
            label: 'Descrição',
            placeholder: 'Escreva algo',
          ),
        ),
      );
      await tester.pump(Duration.zero);

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsNothing);
    });

    testWidgets(
      'validatorMessage set and document empty → validation shows the error',
      (tester) async {
        final controller = QuillController.basic();
        addTearDown(controller.dispose);
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          _harness(
            formKey: formKey,
            RichTextFieldWidget(
              controller: controller,
              label: 'Descrição',
              placeholder: 'Escreva algo',
              validatorMessage: 'Campo obrigatório',
            ),
          ),
        );
        await tester.pump(Duration.zero);

        formKey.currentState!.validate();
        await tester.pump();

        expect(find.text('Campo obrigatório'), findsOneWidget);
      },
    );

    testWidgets('typing content clears a previously shown error', (
      tester,
    ) async {
      final controller = QuillController.basic();
      addTearDown(controller.dispose);
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        _harness(
          formKey: formKey,
          RichTextFieldWidget(
            controller: controller,
            label: 'Descrição',
            placeholder: 'Escreva algo',
            validatorMessage: 'Campo obrigatório',
          ),
        ),
      );
      await tester.pump(Duration.zero);

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);

      controller.replaceText(0, 0, 'Conteúdo digitado', null);
      await tester.pump();

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsNothing);
    });
  });
}
