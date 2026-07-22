import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_tab_bar_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

PreferredSizeWidget _tabBar({Key? key}) {
  return TabBar(
    key: key,
    tabs: const [Tab(text: 'Sobre')],
  );
}

void main() {
  group('DisciplineDetailsTabBarDelegate', () {
    test('minExtent and maxExtent match the tab bar preferred height', () {
      final tabBar = _tabBar();
      final delegate = DisciplineDetailsTabBarDelegate(tabBar);

      expect(delegate.minExtent, tabBar.preferredSize.height);
      expect(delegate.maxExtent, tabBar.preferredSize.height);
    });

    test('shouldRebuild → false for the same tab bar instance', () {
      final tabBar = _tabBar();
      final delegate = DisciplineDetailsTabBarDelegate(tabBar);
      final sameDelegate = DisciplineDetailsTabBarDelegate(tabBar);

      expect(delegate.shouldRebuild(sameDelegate), isFalse);
    });

    test('shouldRebuild → true for a different tab bar instance', () {
      final delegate = DisciplineDetailsTabBarDelegate(_tabBar());
      final otherDelegate = DisciplineDetailsTabBarDelegate(_tabBar());

      expect(delegate.shouldRebuild(otherDelegate), isTrue);
    });

    testWidgets('build renders the tab bar inside a sized container', (
      tester,
    ) async {
      final tabBar = _tabBar();
      final delegate = DisciplineDetailsTabBarDelegate(tabBar);

      await tester.pumpWidget(
        MaterialApp(
          home: DefaultTabController(
            length: 1,
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(delegate: delegate),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Sobre'), findsOneWidget);
    });
  });
}
