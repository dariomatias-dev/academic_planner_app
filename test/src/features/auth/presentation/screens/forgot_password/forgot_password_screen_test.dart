import 'package:academic_planner/src/features/auth/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness() {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ForgotPasswordScreen(),
                ),
              );
            },
            child: const Text('open'),
          );
        },
      ),
    ),
  );
}

void main() {
  group('ForgotPasswordScreen', () {
    testWidgets('renders the title, description, email field and actions', (
      tester,
    ) async {
      await tester.pumpWidget(_harness());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Recuperar Senha'), findsOneWidget);
      expect(
        find.text(
          'Insira seu e-mail abaixo para receber as instruções '
          'de redefinição de senha.',
        ),
        findsOneWidget,
      );
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Enviar Instruções'), findsOneWidget);
      expect(find.text('Voltar para o Login'), findsOneWidget);
    });

    testWidgets('empty submit → shows the required validation error', (
      tester,
    ) async {
      await tester.pumpWidget(_harness());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Enviar Instruções'));
      await tester.pumpAndSettle();

      expect(find.text('Este campo é obrigatório'), findsOneWidget);
    });

    testWidgets('invalid email → shows the email validation error', (
      tester,
    ) async {
      await tester.pumpWidget(_harness());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'not-an-email');
      await tester.tap(find.text('Enviar Instruções'));
      await tester.pumpAndSettle();

      expect(find.text('Insira um e-mail válido'), findsOneWidget);
    });

    testWidgets('valid email submit → shows no validation error', (
      tester,
    ) async {
      await tester.pumpWidget(_harness());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'user@email.com');
      await tester.tap(find.text('Enviar Instruções'));
      await tester.pumpAndSettle();

      expect(find.text('Este campo é obrigatório'), findsNothing);
      expect(find.text('Insira um e-mail válido'), findsNothing);
    });

    testWidgets('tapping "Voltar para o Login" pops the screen', (
      tester,
    ) async {
      await tester.pumpWidget(_harness());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Voltar para o Login'));
      await tester.pumpAndSettle();

      expect(find.text('Recuperar Senha'), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });
  });
}
