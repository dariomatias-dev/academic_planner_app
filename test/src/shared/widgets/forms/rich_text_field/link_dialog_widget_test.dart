import 'dart:async';

import 'package:academic_planner/src/shared/widgets/forms/rich_text_field/link_dialog_widget.dart';
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
                showDialog<Map<String, String>>(
                  context: context,
                  builder: dialogBuilder,
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
  group('LinkDialogWidget', () {
    testWidgets('renders title, message and icon', (tester) async {
      await tester.pumpWidget(_harness((_) => const LinkDialogWidget()));

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Adicionar Link'), findsOneWidget);
      expect(
        find.text(
          'Insira o texto de exibição e o endereço da URL para o link.',
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.link_rounded), findsOneWidget);
    });

    testWidgets('prefills text and url fields with initial values', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          (_) => const LinkDialogWidget(
            initialText: 'Documentação',
            initialUrl: 'https://docs.flutter.dev',
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Documentação'), findsOneWidget);
      expect(find.text('https://docs.flutter.dev'), findsOneWidget);
    });

    testWidgets(
      'tap "Adicionar" with empty fields → shows required errors and '
      'keeps the dialog open',
      (tester) async {
        await tester.pumpWidget(_harness((_) => const LinkDialogWidget()));

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Adicionar'));
        await tester.pumpAndSettle();

        expect(find.text('Este campo é obrigatório'), findsNWidgets(2));
        expect(find.text('Adicionar Link'), findsOneWidget);
      },
    );

    testWidgets(
      'tap "Adicionar" with an invalid url → shows the url error only',
      (tester) async {
        await tester.pumpWidget(_harness((_) => const LinkDialogWidget()));

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextFormField).first,
          'Documentação',
        );
        await tester.enterText(
          find.byType(TextFormField).last,
          'not a url',
        );
        await tester.tap(find.text('Adicionar'));
        await tester.pumpAndSettle();

        expect(find.text('Este campo é obrigatório'), findsNothing);
        expect(find.text('Insira um link válido'), findsOneWidget);
      },
    );

    testWidgets('tap "Cancelar" → closes the dialog and returns null', (
      tester,
    ) async {
      Map<String, String>? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    unawaited(
                      LinkDialogWidget.show(context).then((value) {
                        result = value;
                      }),
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

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(result, isNull);
      expect(find.text('Adicionar Link'), findsNothing);
    });

    testWidgets(
      'tap "Adicionar" with valid fields → closes the dialog and returns '
      'the text and url',
      (tester) async {
        Map<String, String>? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      unawaited(
                        LinkDialogWidget.show(context).then((value) {
                          result = value;
                        }),
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

        await tester.enterText(
          find.byType(TextFormField).first,
          'Documentação',
        );
        await tester.enterText(
          find.byType(TextFormField).last,
          'https://docs.flutter.dev',
        );
        await tester.tap(find.text('Adicionar'));
        await tester.pumpAndSettle();

        expect(result, {
          'text': 'Documentação',
          'url': 'https://docs.flutter.dev',
        });
        expect(find.text('Adicionar Link'), findsNothing);
      },
    );
  });
}
