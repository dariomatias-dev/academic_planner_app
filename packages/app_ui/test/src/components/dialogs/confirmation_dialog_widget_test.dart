import 'dart:async';

import 'package:app_ui/src/components/dialogs/confirmation_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('ConfirmationDialogWidget', () {
    testWidgets('renders title, message and default labels', (tester) async {
      await pumpScopedApp(
        tester,
        (context) => unawaited(
          showDialog<void>(
            context: context,
            builder: (_) => ConfirmationDialogWidget(
              confirmLabel: 'Confirmar',
              cancelLabel: 'Cancelar',
              title: 'Excluir item',
              message: 'Tem certeza?',
              onConfirm: () {},
            ),
          ),
        ),
        triggerLabel: 'open',
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir item'), findsOneWidget);
      expect(find.text('Tem certeza?'), findsOneWidget);
      expect(find.text('Confirmar'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('renders custom labels when provided', (tester) async {
      await pumpScopedApp(
        tester,
        (context) => unawaited(
          showDialog<void>(
            context: context,
            builder: (_) => ConfirmationDialogWidget(
              title: 'Excluir item',
              message: 'Tem certeza?',
              onConfirm: () {},
              confirmLabel: 'Excluir',
              cancelLabel: 'Voltar',
            ),
          ),
        ),
        triggerLabel: 'open',
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir'), findsOneWidget);
      expect(find.text('Voltar'), findsOneWidget);
    });

    testWidgets('renders the icon when provided', (tester) async {
      await pumpScopedApp(
        tester,
        (context) => unawaited(
          showDialog<void>(
            context: context,
            builder: (_) => ConfirmationDialogWidget(
              confirmLabel: 'Confirmar',
              cancelLabel: 'Cancelar',
              title: 'Excluir item',
              message: 'Tem certeza?',
              onConfirm: () {},
              icon: Icons.warning_rounded,
            ),
          ),
        ),
        triggerLabel: 'open',
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.warning_rounded), findsOneWidget);
    });

    testWidgets('tap cancel → closes the dialog without calling onConfirm', (
      tester,
    ) async {
      var confirmCalls = 0;

      await pumpScopedApp(
        tester,
        (context) => unawaited(
          showDialog<void>(
            context: context,
            builder: (_) => ConfirmationDialogWidget(
              confirmLabel: 'Confirmar',
              cancelLabel: 'Cancelar',
              title: 'Excluir item',
              message: 'Tem certeza?',
              onConfirm: () => confirmCalls++,
            ),
          ),
        ),
        triggerLabel: 'open',
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

      await pumpScopedApp(
        tester,
        (context) => unawaited(
          showDialog<void>(
            context: context,
            builder: (_) => ConfirmationDialogWidget(
              confirmLabel: 'Confirmar',
              cancelLabel: 'Cancelar',
              title: 'Excluir item',
              message: 'Tem certeza?',
              onConfirm: () => confirmCalls++,
            ),
          ),
        ),
        triggerLabel: 'open',
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
      await pumpScopedApp(
        tester,
        (context) => unawaited(
          showDialog<void>(
            context: context,
            builder: (_) => ConfirmationDialogWidget(
              confirmLabel: 'Confirmar',
              cancelLabel: 'Cancelar',
              title: 'Excluir item',
              message: 'Tem certeza?',
              onConfirm: () {},
              vertical: true,
            ),
          ),
        ),
        triggerLabel: 'open',
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final confirmY = tester.getTopLeft(find.text('Confirmar')).dy;
      final cancelY = tester.getTopLeft(find.text('Cancelar')).dy;

      expect(confirmY, lessThan(cancelY));
    });
  });
}
