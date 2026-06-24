import 'dart:async';

import 'package:academic_planner/src/shared/widgets/dialogs/removal_confirm_dialog_widget.dart';
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
  group('RemovalConfirmDialogWidget', () {
    testWidgets('renders title, message and action labels', (tester) async {
      await tester.pumpWidget(
        _harness(
          (_) => RemovalConfirmDialogWidget(
            title: 'Excluir nota',
            message: 'Tem certeza?',
            onConfirm: () async {},
          ),
        ),
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

        await tester.pumpWidget(
          _harness(
            (_) => RemovalConfirmDialogWidget(
              title: 'Excluir nota',
              message: 'Tem certeza?',
              onConfirm: () async => confirmCalls++,
            ),
          ),
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

        await tester.pumpWidget(
          _harness(
            (_) => RemovalConfirmDialogWidget(
              title: 'Excluir nota',
              message: 'Tem certeza?',
              onConfirm: () async => confirmCalls++,
            ),
          ),
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
