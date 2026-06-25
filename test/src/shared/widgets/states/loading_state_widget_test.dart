import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('LoadingStateWidget', () {
    testWidgets('renders the default message and a progress indicator', (
      tester,
    ) async {
      await tester.pumpWidget(_harness(const LoadingStateWidget()));

      expect(find.text('Obtendo informações...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('forwards a custom message', (tester) async {
      await tester.pumpWidget(
        _harness(const LoadingStateWidget(message: 'Carregando notas...')),
      );

      expect(find.text('Carregando notas...'), findsOneWidget);
    });

    testWidgets('isCentered true (default) → wraps the content in Center', (
      tester,
    ) async {
      await tester.pumpWidget(_harness(const LoadingStateWidget()));

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
        _harness(const LoadingStateWidget(isCentered: false)),
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
