import 'package:academic_planner/src/shared/widgets/states/error_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ErrorStateWidget', () {
    testWidgets(
      'renders default icon, title and description, without an action',
      (tester) async {
        await tester.pumpWidget(
          _harness(const ErrorStateWidget(description: 'Tente mais tarde')),
        );

        expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
        expect(find.text('Ops! Algo deu errado'), findsOneWidget);
        expect(find.text('Tente mais tarde'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsNothing);
      },
    );

    testWidgets('forwards a custom icon and title', (tester) async {
      await tester.pumpWidget(
        _harness(
          const ErrorStateWidget(
            description: 'Tente mais tarde',
            icon: Icons.wifi_off_rounded,
            title: 'Sem conexão',
          ),
        ),
      );

      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
      expect(find.text('Sem conexão'), findsOneWidget);
    });

    testWidgets(
      'onActionPressed provided → shows the action button and calls it '
      'on tap',
      (tester) async {
        var calls = 0;

        await tester.pumpWidget(
          _harness(
            ErrorStateWidget(
              description: 'Tente mais tarde',
              actionLabel: 'Recarregar',
              onActionPressed: () => calls++,
            ),
          ),
        );

        expect(find.text('Recarregar'), findsOneWidget);

        await tester.tap(find.text('Recarregar'));
        await tester.pumpAndSettle();

        expect(calls, 1);
      },
    );

    testWidgets('isCentered true (default) → wraps the content in Center', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(const ErrorStateWidget(description: 'Tente mais tarde')),
      );

      expect(
        find.ancestor(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Center),
        ),
        findsOneWidget,
      );
    });

    testWidgets('isCentered false → does not wrap the content in Center', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const ErrorStateWidget(
            description: 'Tente mais tarde',
            isCentered: false,
          ),
        ),
      );

      expect(
        find.ancestor(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Center),
        ),
        findsNothing,
      );

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, MainAxisAlignment.start);
    });
  });
}
