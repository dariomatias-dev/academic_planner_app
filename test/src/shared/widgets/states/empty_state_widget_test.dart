import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('EmptyStateWidget', () {
    testWidgets('renders the icon, title and description', (tester) async {
      await tester.pumpWidget(
        _harness(
          const EmptyStateWidget(
            icon: Icons.inbox_outlined,
            title: 'Nada por aqui',
            description: 'Você ainda não criou nenhum item.',
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.text('Nada por aqui'), findsOneWidget);
      expect(
        find.text('Você ainda não criou nenhum item.'),
        findsOneWidget,
      );
    });

    testWidgets('no actionLabel and no onActionPressed → no button', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const EmptyStateWidget(
            icon: Icons.inbox_outlined,
            title: 'Nada por aqui',
            description: 'Você ainda não criou nenhum item.',
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('only onActionPressed without actionLabel → no button', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          EmptyStateWidget(
            icon: Icons.inbox_outlined,
            title: 'Nada por aqui',
            description: 'Você ainda não criou nenhum item.',
            onActionPressed: () {},
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets(
      'actionLabel and onActionPressed provided → shows the button and '
      'calls it on tap',
      (tester) async {
        var calls = 0;

        await tester.pumpWidget(
          _harness(
            EmptyStateWidget(
              icon: Icons.inbox_outlined,
              title: 'Nada por aqui',
              description: 'Você ainda não criou nenhum item.',
              actionLabel: 'Criar item',
              onActionPressed: () => calls++,
            ),
          ),
        );

        expect(find.text('Criar item'), findsOneWidget);

        await tester.tap(find.text('Criar item'));
        await tester.pumpAndSettle();

        expect(calls, 1);
      },
    );

    testWidgets('isCentered true (default) → wraps the content in Center', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const EmptyStateWidget(
            icon: Icons.inbox_outlined,
            title: 'Nada por aqui',
            description: 'Você ainda não criou nenhum item.',
          ),
        ),
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
          const EmptyStateWidget(
            icon: Icons.inbox_outlined,
            title: 'Nada por aqui',
            description: 'Você ainda não criou nenhum item.',
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
