import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/theme_selector_modal/theme_selector_modal_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ThemeSelectorModalOptionWidget', () {
    testWidgets('not selected → renders no check icon', (tester) async {
      await tester.pumpWidget(
        _harness(
          ThemeSelectorModalOptionWidget(
            onTap: () {},
            label: 'Modo Claro',
            icon: Icons.light_mode_rounded,
            isSelected: false,
          ),
        ),
      );

      expect(find.text('Modo Claro'), findsOneWidget);
      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
    });

    testWidgets('selected → renders the check icon', (tester) async {
      await tester.pumpWidget(
        _harness(
          ThemeSelectorModalOptionWidget(
            onTap: () {},
            label: 'Modo Claro',
            icon: Icons.light_mode_rounded,
            isSelected: true,
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('tapping the option calls onTap', (tester) async {
      var tapCalls = 0;

      await tester.pumpWidget(
        _harness(
          ThemeSelectorModalOptionWidget(
            onTap: () => tapCalls++,
            label: 'Modo Claro',
            icon: Icons.light_mode_rounded,
            isSelected: false,
          ),
        ),
      );

      await tester.tap(find.text('Modo Claro'));

      expect(tapCalls, 1);
    });
  });
}
