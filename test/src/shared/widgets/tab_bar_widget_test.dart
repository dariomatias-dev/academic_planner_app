import 'package:academic_planner/src/shared/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('TabBarWidget', () {
    test('preferredSize height is kToolbarHeight', () {
      final controller = TabController(length: 1, vsync: const TestVSync());
      addTearDown(controller.dispose);

      final tabBar = TabBarWidget(
        controller: controller,
        tabs: const [Tab(text: 'A')],
      );

      expect(tabBar.preferredSize.height, kToolbarHeight);
    });

    testWidgets('renders the given tabs', (tester) async {
      final controller = TabController(length: 2, vsync: const TestVSync());
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          TabBarWidget(
            controller: controller,
            tabs: const [
              Tab(text: 'Manhã'),
              Tab(text: 'Tarde'),
            ],
          ),
        ),
      );

      expect(find.text('Manhã'), findsOneWidget);
      expect(find.text('Tarde'), findsOneWidget);
    });

    testWidgets('tap on a tab moves the controller to its index', (
      tester,
    ) async {
      final controller = TabController(length: 2, vsync: const TestVSync());
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          TabBarWidget(
            controller: controller,
            tabs: const [
              Tab(text: 'Manhã'),
              Tab(text: 'Tarde'),
            ],
          ),
        ),
      );

      expect(controller.index, 0);

      await tester.tap(find.text('Tarde'));
      await tester.pumpAndSettle();

      expect(controller.index, 1);
    });

    testWidgets('backgroundColor defaults to transparent', (tester) async {
      final controller = TabController(length: 1, vsync: const TestVSync());
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          TabBarWidget(
            controller: controller,
            tabs: const [Tab(text: 'A')],
          ),
        ),
      );

      final material = tester.widget<Material>(
        find
            .ancestor(of: find.byType(TabBar), matching: find.byType(Material))
            .first,
      );

      expect(material.color, Colors.transparent);
    });

    testWidgets('backgroundColor override is applied', (tester) async {
      final controller = TabController(length: 1, vsync: const TestVSync());
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          TabBarWidget(
            controller: controller,
            tabs: const [Tab(text: 'A')],
            backgroundColor: Colors.amber,
          ),
        ),
      );

      final material = tester.widget<Material>(
        find
            .ancestor(of: find.byType(TabBar), matching: find.byType(Material))
            .first,
      );

      expect(material.color, Colors.amber);
    });

    testWidgets('forwards the theme colors to the TabBar', (tester) async {
      final controller = TabController(length: 1, vsync: const TestVSync());
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(
          TabBarWidget(
            controller: controller,
            tabs: const [Tab(text: 'A')],
          ),
        ),
      );

      final context = tester.element(find.byType(TabBarWidget));
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));

      expect(tabBar.labelColor, colorScheme.primary);
      expect(
        tabBar.unselectedLabelColor,
        colorScheme.onSurface.withAlpha(160),
      );
      expect(tabBar.indicatorColor, colorScheme.primary);
      expect(tabBar.indicatorWeight, 3.0);
      expect(tabBar.dividerColor, theme.dividerTheme.color);
      expect(tabBar.labelStyle?.fontWeight, FontWeight.w800);
      expect(tabBar.unselectedLabelStyle?.fontWeight, FontWeight.w600);
    });
  });
}
