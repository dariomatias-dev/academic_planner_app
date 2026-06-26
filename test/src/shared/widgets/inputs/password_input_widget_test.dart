import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/password_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('PasswordInputWidget', () {
    testWidgets('renders the default masked hint and lock icon', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(PasswordInputWidget(controller: controller)),
      );

      expect(find.text('••••••••'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    });

    testWidgets('forwards a custom hint', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          PasswordInputWidget(controller: controller, hint: 'Sua senha'),
        ),
      );

      expect(find.text('Sua senha'), findsOneWidget);
    });

    testWidgets('starts obscured and toggles visibility on tap', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(PasswordInputWidget(controller: controller)),
      );

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue,
      );
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse,
      );
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue,
      );
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('validator runs and shows the error message', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          PasswordInputWidget(
            controller: controller,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Obrigatório' : null,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();

      expect(find.text('Obrigatório'), findsOneWidget);
    });

    testWidgets('forwards the style to the underlying InputWidget', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          PasswordInputWidget(
            controller: controller,
            style: InputStyle.secondary,
          ),
        ),
      );

      final inputWidget = tester.widget<InputWidget>(
        find.byType(InputWidget),
      );
      expect(inputWidget.style, InputStyle.secondary);
    });
  });
}
