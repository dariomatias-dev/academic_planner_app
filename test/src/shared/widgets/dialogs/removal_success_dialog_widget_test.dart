import 'dart:async';

import 'package:academic_planner/src/shared/widgets/dialogs/removal_success_dialog_widget.dart';
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
  group('RemovalSuccessDialogWidget', () {
    testWidgets('renders title, message and the icon', (tester) async {
      await tester.pumpWidget(
        _harness(
          (_) => const RemovalSuccessDialogWidget(
            title: 'Excluído',
            message: 'Nota removida com sucesso',
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Excluído'), findsOneWidget);
      expect(find.text('Nota removida com sucesso'), findsOneWidget);
      expect(
        find.byIcon(Icons.check_circle_outline_rounded),
        findsOneWidget,
      );
      expect(find.text('Entendido'), findsOneWidget);
    });

    testWidgets('tap "Entendido" closes the dialog', (tester) async {
      await tester.pumpWidget(
        _harness(
          (_) => const RemovalSuccessDialogWidget(
            title: 'Excluído',
            message: 'Nota removida com sucesso',
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();

      expect(find.text('Excluído'), findsNothing);
    });

    testWidgets('show() displays the dialog via showDialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    unawaited(
                      RemovalSuccessDialogWidget.show(
                        context,
                        title: 'Excluído',
                        message: 'Nota removida com sucesso',
                      ),
                    );
                  },
                  child: const Text('open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Excluído'), findsOneWidget);
    });
  });
}
