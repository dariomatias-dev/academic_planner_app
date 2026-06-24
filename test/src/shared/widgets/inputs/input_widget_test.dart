import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: Center(child: child)));
}

void main() {
  group('InputWidget', () {
    testWidgets('renders the hint when the controller is empty', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(InputWidget(controller: controller, hint: 'Digite aqui')),
      );

      expect(find.text('Digite aqui'), findsOneWidget);
    });

    testWidgets('typing updates the controller', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(InputWidget(controller: controller, hint: 'Digite aqui')),
      );

      await tester.enterText(find.byType(TextFormField), 'Olá mundo');

      expect(controller.text, 'Olá mundo');
    });

    testWidgets(
      'validator runs on user interaction and clears once valid',
      (tester) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _harness(
            InputWidget(
              controller: controller,
              hint: 'Digite aqui',
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Obrigatório' : null,
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'a');
        await tester.enterText(find.byType(TextFormField), '');
        await tester.pump();

        expect(find.text('Obrigatório'), findsOneWidget);

        await tester.enterText(find.byType(TextFormField), 'abc');
        await tester.pump();

        expect(find.text('Obrigatório'), findsNothing);
      },
    );

    testWidgets(
      'prefixIcon → renders at full opacity, dimmed when readOnly',
      (tester) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _harness(
            InputWidget(
              controller: controller,
              hint: 'Digite aqui',
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ),
        );

        var opacity = tester.widget<Opacity>(
          find.ancestor(
            of: find.byIcon(Icons.email_outlined),
            matching: find.byType(Opacity),
          ),
        );
        expect(opacity.opacity, 1.0);

        await tester.pumpWidget(
          _harness(
            InputWidget(
              controller: controller,
              hint: 'Digite aqui',
              prefixIcon: const Icon(Icons.email_outlined),
              readOnly: true,
            ),
          ),
        );

        opacity = tester.widget<Opacity>(
          find.ancestor(
            of: find.byIcon(Icons.email_outlined),
            matching: find.byType(Opacity),
          ),
        );
        expect(opacity.opacity, 0.5);
      },
    );

    testWidgets(
      'default suffix → clear button appears once there is text and '
      'clears the controller on tap',
      (tester) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _harness(InputWidget(controller: controller, hint: 'Digite aqui')),
        );

        expect(find.byIcon(Icons.clear_rounded), findsNothing);

        await tester.enterText(find.byType(TextFormField), 'abc');
        await tester.pump();

        expect(find.byIcon(Icons.clear_rounded), findsOneWidget);

        await tester.tap(find.byIcon(Icons.clear_rounded));
        await tester.pump();

        expect(controller.text, isEmpty);
        expect(find.byIcon(Icons.clear_rounded), findsNothing);
      },
    );

    testWidgets('custom suffix overrides the default clear button', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'abc');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          InputWidget(
            controller: controller,
            hint: 'Digite aqui',
            suffix: const Icon(Icons.search),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.clear_rounded), findsNothing);
    });

    testWidgets(
      'readOnly → shows the lock icon instead of any suffix and ignores it',
      (tester) async {
        final controller = TextEditingController(text: 'abc');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _harness(
            InputWidget(
              controller: controller,
              hint: 'Digite aqui',
              readOnly: true,
              suffix: const Icon(Icons.search),
            ),
          ),
        );

        expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
        expect(find.byIcon(Icons.search), findsNothing);
        expect(find.byIcon(Icons.clear_rounded), findsNothing);

        final field = tester.widget<EditableText>(
          find.byType(EditableText),
        );
        expect(field.readOnly, isTrue);
      },
    );

    testWidgets('obscureText → forces maxLines to 1 even if set higher', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          InputWidget(
            controller: controller,
            hint: 'Senha',
            obscureText: true,
            maxLines: 5,
          ),
        ),
      );

      final field = tester.widget<EditableText>(find.byType(EditableText));
      expect(field.maxLines, 1);
    });

    testWidgets('onSubmitted is called with the field value', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      String? submitted;

      await tester.pumpWidget(
        _harness(
          InputWidget(
            controller: controller,
            hint: 'Digite aqui',
            onSubmitted: (value) => submitted = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'abc');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(submitted, 'abc');
    });
  });
}
