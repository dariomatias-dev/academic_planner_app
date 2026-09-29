import 'package:academic_planner/src/shared/widgets/popup_menu/popup_menu_widget.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('PopupMenuWidget', () {
    testWidgets('renders the default icon', (tester) async {
      await pumpApp(
        tester,
        PopupMenuWidget<String>(
          items: const [
            PopupMenuItem(value: 'a', child: Text('Item A')),
          ],
        ),
      );

      expect(find.byIcon(Icons.more_vert_rounded), findsOneWidget);
    });

    testWidgets('renders a custom icon when provided', (tester) async {
      await pumpApp(
        tester,
        PopupMenuWidget<String>(
          icon: Icons.filter_list,
          items: const [
            PopupMenuItem(value: 'a', child: Text('Item A')),
          ],
        ),
      );

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('tap → opens the menu listing the items', (tester) async {
      await pumpApp(
        tester,
        PopupMenuWidget<String>(
          items: const [
            PopupMenuItem(value: 'a', child: Text('Item A')),
            PopupMenuItem(value: 'b', child: Text('Item B')),
          ],
        ),
      );

      expect(find.text('Item A'), findsNothing);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(find.text('Item A'), findsOneWidget);
      expect(find.text('Item B'), findsOneWidget);
    });

    testWidgets('selecting an item calls its onTap and closes the menu', (
      tester,
    ) async {
      var calls = 0;

      await pumpApp(
        tester,
        PopupMenuWidget<String>(
          items: [
            PopupMenuItem(
              value: 'a',
              onTap: () => calls++,
              child: const Text('Item A'),
            ),
          ],
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Item A'));
      await tester.pumpAndSettle();

      expect(calls, 1);
      expect(find.text('Item A'), findsNothing);
    });

    testWidgets('tapping the icon again after closing reopens the menu', (
      tester,
    ) async {
      await pumpApp(
        tester,
        PopupMenuWidget<String>(
          items: const [
            PopupMenuItem(value: 'a', child: Text('Item A')),
          ],
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Item A'));
      await tester.pumpAndSettle();

      expect(find.text('Item A'), findsNothing);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(find.text('Item A'), findsOneWidget);
    });

    testWidgets('forwards the style to the trigger IconButtonWidget', (
      tester,
    ) async {
      await pumpApp(
        tester,
        PopupMenuWidget<String>(
          style: IconButtonStyle.outline,
          items: const [
            PopupMenuItem(value: 'a', child: Text('Item A')),
          ],
        ),
      );

      final trigger = tester.widget<IconButtonWidget>(
        find.byType(IconButtonWidget),
      );

      expect(trigger.style, IconButtonStyle.outline);
    });
  });
}
