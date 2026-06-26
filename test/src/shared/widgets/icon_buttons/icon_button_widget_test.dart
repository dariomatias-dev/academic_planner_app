import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('IconButtonWidget', () {
    testWidgets('renders the icon', (tester) async {
      await tester.pumpWidget(
        _harness(IconButtonWidget(icon: Icons.add, onPressed: () {})),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('tap calls onPressed', (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        _harness(
          IconButtonWidget(icon: Icons.add, onPressed: () => calls++),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(calls, 1);
    });

    testWidgets('onPressed null → button is disabled with dimmed colors', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(const IconButtonWidget(icon: Icons.add, onPressed: null)),
      );

      final context = tester.element(find.byIcon(Icons.add));
      final colorScheme = Theme.of(context).colorScheme;

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNull);
      expect(
        iconButton.style?.backgroundColor?.resolve({}),
        colorScheme.onSurface.withAlpha(255),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.add));
      expect(icon.color, colorScheme.onSurface.withAlpha(60));
    });

    testWidgets(
      'default size → 48.0 fixed/minimum size and icon size at 0.58 ratio',
      (tester) async {
        await tester.pumpWidget(
          _harness(IconButtonWidget(icon: Icons.add, onPressed: () {})),
        );

        final iconButton = tester.widget<IconButton>(
          find.byType(IconButton),
        );
        expect(
          iconButton.style?.fixedSize?.resolve({}),
          const Size(48.0, 48.0),
        );
        expect(
          iconButton.style?.minimumSize?.resolve({}),
          const Size(48.0, 48.0),
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.add));
        expect(icon.size, 48.0 * 0.58);
      },
    );

    testWidgets('custom size and iconSize are forwarded', (tester) async {
      await tester.pumpWidget(
        _harness(
          IconButtonWidget(
            icon: Icons.add,
            onPressed: () {},
            size: 64.0,
            iconSize: 20.0,
          ),
        ),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(
        iconButton.style?.fixedSize?.resolve({}),
        const Size(64.0, 64.0),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.add));
      expect(icon.size, 20.0);
    });

    testWidgets('renders for every IconButtonStyle without throwing', (
      tester,
    ) async {
      for (final style in IconButtonStyle.values) {
        await tester.pumpWidget(
          _harness(
            IconButtonWidget(
              icon: Icons.add,
              onPressed: () {},
              style: style,
            ),
          ),
        );

        expect(find.byIcon(Icons.add), findsOneWidget);
      }
    });

    testWidgets(
      'each enabled style resolves the expected background and icon colors',
      (tester) async {
        await tester.pumpWidget(
          _harness(
            IconButtonWidget(
              icon: Icons.add,
              onPressed: () {},
              style: IconButtonStyle.primary,
            ),
          ),
        );

        var context = tester.element(find.byIcon(Icons.add));
        var colorScheme = Theme.of(context).colorScheme;
        var iconButton = tester.widget<IconButton>(find.byType(IconButton));

        expect(
          iconButton.style?.backgroundColor?.resolve({}),
          colorScheme.primary.withAlpha(20),
        );
        expect(
          tester.widget<Icon>(find.byIcon(Icons.add)).color,
          colorScheme.primary,
        );

        await tester.pumpWidget(
          _harness(
            IconButtonWidget(
              icon: Icons.add,
              onPressed: () {},
              style: IconButtonStyle.secondary,
            ),
          ),
        );

        context = tester.element(find.byIcon(Icons.add));
        colorScheme = Theme.of(context).colorScheme;
        iconButton = tester.widget<IconButton>(find.byType(IconButton));

        expect(
          iconButton.style?.backgroundColor?.resolve({}),
          colorScheme.primary.withAlpha(25),
        );
        expect(
          tester.widget<Icon>(find.byIcon(Icons.add)).color,
          colorScheme.primary,
        );

        await tester.pumpWidget(
          _harness(IconButtonWidget(icon: Icons.add, onPressed: () {})),
        );

        context = tester.element(find.byIcon(Icons.add));
        final theme = Theme.of(context);
        iconButton = tester.widget<IconButton>(find.byType(IconButton));

        expect(
          iconButton.style?.backgroundColor?.resolve({}),
          theme.scaffoldBackgroundColor,
        );
        expect(
          tester.widget<Icon>(find.byIcon(Icons.add)).color,
          theme.colorScheme.onSurface,
        );
      },
    );

    testWidgets('style outline → transparent background and a border', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            dividerTheme: const DividerThemeData(color: Colors.grey),
          ),
          home: Scaffold(
            body: Center(
              child: IconButtonWidget(
                icon: Icons.add,
                onPressed: () {},
                style: IconButtonStyle.outline,
              ),
            ),
          ),
        ),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(
        iconButton.style?.backgroundColor?.resolve({}),
        AppColors.transparent,
      );

      final shape =
          iconButton.style?.shape?.resolve({}) as RoundedRectangleBorder?;
      expect(shape?.side.color, Colors.grey);
      expect(shape?.side.style, BorderStyle.solid);
    });
  });
}
