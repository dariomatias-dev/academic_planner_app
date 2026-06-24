import 'dart:async';

import 'package:academic_planner/src/shared/widgets/dialogs/confirmation_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget Function(BuildContext context) dialogBuilder) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              unawaited(
                showDialog<void>(context: context, builder: dialogBuilder),
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
  group('ConfirmationDialogWidget', () {
    testWidgets('renders title, message and default labels', (tester) async {
      await tester.pumpWidget(
        _harness(
          (_) => ConfirmationDialogWidget(
            title: 'Excluir item',
            message: 'Tem certeza?',
            onConfirm: () {},
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir item'), findsOneWidget);
      expect(find.text('Tem certeza?'), findsOneWidget);
      expect(find.text('Confirmar'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('renders custom labels when provided', (tester) async {
      await tester.pumpWidget(
        _harness(
          (_) => ConfirmationDialogWidget(
            title: 'Excluir item',
            message: 'Tem certeza?',
            onConfirm: () {},
            confirmLabel: 'Excluir',
            cancelLabel: 'Voltar',
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir'), findsOneWidget);
      expect(find.text('Voltar'), findsOneWidget);
    });

    testWidgets('renders the icon when provided', (tester) async {
      await tester.pumpWidget(
        _harness(
          (_) => ConfirmationDialogWidget(
            title: 'Excluir item',
            message: 'Tem certeza?',
            onConfirm: () {},
            icon: Icons.warning_rounded,
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.warning_rounded), findsOneWidget);
    });

    testWidgets('tap cancel → closes the dialog without calling onConfirm', (
      tester,
    ) async {
      var confirmCalls = 0;

      await tester.pumpWidget(
        _harness(
          (_) => ConfirmationDialogWidget(
            title: 'Excluir item',
            message: 'Tem certeza?',
            onConfirm: () => confirmCalls++,
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(confirmCalls, 0);
      expect(find.text('Excluir item'), findsNothing);
    });

    testWidgets('tap confirm → closes the dialog and calls onConfirm', (
      tester,
    ) async {
      var confirmCalls = 0;

      await tester.pumpWidget(
        _harness(
          (_) => ConfirmationDialogWidget(
            title: 'Excluir item',
            message: 'Tem certeza?',
            onConfirm: () => confirmCalls++,
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      expect(confirmCalls, 1);
      expect(find.text('Excluir item'), findsNothing);
    });

    testWidgets('vertical → stacks the confirm button above the cancel one', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          (_) => ConfirmationDialogWidget(
            title: 'Excluir item',
            message: 'Tem certeza?',
            onConfirm: () {},
            vertical: true,
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final confirmY = tester.getTopLeft(find.text('Confirmar')).dy;
      final cancelY = tester.getTopLeft(find.text('Cancelar')).dy;

      expect(confirmY, lessThan(cancelY));
    });
  });
}
