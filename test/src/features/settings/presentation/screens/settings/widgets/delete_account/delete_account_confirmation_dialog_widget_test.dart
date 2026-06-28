import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/delete_account/delete_account_confirmation_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness() {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                await DeleteAccountConfirmationDialogWidget.show(context);
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    ),
  );
}

void main() {
  group('DeleteAccountConfirmationDialogWidget', () {
    testWidgets('renders the warning message', (tester) async {
      await tester.pumpWidget(_harness());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir Conta'), findsOneWidget);
      expect(
        find.textContaining('Esta ação é irreversível'),
        findsOneWidget,
      );
    });

    testWidgets('tapping "Cancelar" closes without advancing', (
      tester,
    ) async {
      await tester.pumpWidget(_harness());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir Conta'), findsNothing);
      expect(find.text('Confirmação Final'), findsNothing);
    });

    testWidgets('tapping "Continuar" opens the final confirmation dialog', (
      tester,
    ) async {
      await tester.pumpWidget(_harness());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      expect(find.text('Confirmação Final'), findsOneWidget);
      expect(find.text('Excluir Permanentemente'), findsOneWidget);
    });
  });
}
