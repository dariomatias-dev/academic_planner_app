import 'dart:async';

import 'package:app_ui/src/components/dialogs/removal_confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('RemovalConfirmDialogWidget', () {
    testWidgets('renders title, message and action labels', (tester) async {
      await pumpScopedApp(
        tester,
        (context) => unawaited(
          showDialog<void>(
            context: context,
            builder: (_) => RemovalConfirmDialogWidget(
              cancelLabel: 'Cancelar',
              confirmLabel: 'Excluir',
              title: 'Excluir nota',
              message: 'Tem certeza?',
              onConfirm: () async {},
            ),
          ),
        ),
        triggerLabel: 'open',
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir nota'), findsOneWidget);
      expect(find.text('Tem certeza?'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Excluir'), findsOneWidget);
    });

    testWidgets(
      'tap "Cancelar" → closes the dialog without calling onConfirm',
      (tester) async {
        var confirmCalls = 0;

        await pumpScopedApp(
          tester,
          (context) => unawaited(
            showDialog<void>(
              context: context,
              builder: (_) => RemovalConfirmDialogWidget(
                cancelLabel: 'Cancelar',
                confirmLabel: 'Excluir',
                title: 'Excluir nota',
                message: 'Tem certeza?',
                onConfirm: () async => confirmCalls++,
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
        expect(find.text('Excluir nota'), findsNothing);
      },
    );

    testWidgets(
      'tap "Excluir" → calls onConfirm and leaves closing it up to the '
      'caller',
      (tester) async {
        var confirmCalls = 0;

        await pumpScopedApp(
          tester,
          (context) => unawaited(
            showDialog<void>(
              context: context,
              builder: (_) => RemovalConfirmDialogWidget(
                cancelLabel: 'Cancelar',
                confirmLabel: 'Excluir',
                title: 'Excluir nota',
                message: 'Tem certeza?',
                onConfirm: () async => confirmCalls++,
              ),
            ),
          ),
          triggerLabel: 'open',
        );

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Excluir'));
        await tester.pumpAndSettle();

        expect(confirmCalls, 1);
        expect(find.text('Excluir nota'), findsOneWidget);
      },
    );
  });
}
