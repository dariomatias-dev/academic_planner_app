import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: Center(child: child)));
}

void main() {
  group('DialogWidget', () {
    testWidgets('renders title, message and actions', (tester) async {
      await tester.pumpWidget(
        _harness(
          const DialogWidget(
            title: 'Título',
            message: 'Mensagem',
            actions: Text('AÇÃO'),
          ),
        ),
      );

      expect(find.text('Título'), findsOneWidget);
      expect(find.text('Mensagem'), findsOneWidget);
      expect(find.text('AÇÃO'), findsOneWidget);
    });

    testWidgets('icon null → no icon rendered', (tester) async {
      await tester.pumpWidget(
        _harness(
          const DialogWidget(
            title: 'Título',
            message: 'Mensagem',
            actions: SizedBox.shrink(),
          ),
        ),
      );

      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('icon provided → renders it with the given iconColor', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const DialogWidget(
            title: 'Título',
            message: 'Mensagem',
            icon: Icons.warning_rounded,
            iconColor: Colors.red,
            actions: SizedBox.shrink(),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.warning_rounded));

      expect(icon.color, Colors.red);
    });

    testWidgets('iconColor null → falls back to colorScheme.primary', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const DialogWidget(
            title: 'Título',
            message: 'Mensagem',
            icon: Icons.warning_rounded,
            actions: SizedBox.shrink(),
          ),
        ),
      );

      final context = tester.element(find.byIcon(Icons.warning_rounded));
      final icon = tester.widget<Icon>(find.byIcon(Icons.warning_rounded));

      expect(icon.color, Theme.of(context).colorScheme.primary);
    });
  });
}
