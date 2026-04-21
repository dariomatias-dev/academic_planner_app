import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/di/navigation_provider.dart';

import 'package:academic_planner/src/features/activities/presentation/screens/activities/activities_screen.dart';
import 'package:academic_planner/src/features/home/home_screen.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/my_disciplines/my_disciplines_screen.dart';
import 'package:academic_planner/src/features/settings/settings_screen.dart';

import 'package:academic_planner/src/shared/widgets/nav_bar/nav_bar_widget.dart';

class RootNavigation extends ConsumerStatefulWidget {
  const RootNavigation({super.key});

  @override
  ConsumerState<RootNavigation> createState() => _RootNavigationState();
}

class _RootNavigationState extends ConsumerState<RootNavigation> {
  late final PageController _pageController;

  final _screens = <Widget>[
    const HomeScreen(),
    const MyDisciplinesScreen(showBackButton: false),
    const ActivitiesScreenWidget(),
    const SettingsScreen(),
  ];

  void _handleNavigationChange(int index) {
    if (_pageController.hasClients && _pageController.page?.round() != index) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    ref.read(navigationNotifierProvider.notifier).setIndex(index);
  }

  void _onNavBarTap(int index) {
    ref.read(navigationNotifierProvider.notifier).setIndex(index);
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: ref.read(navigationNotifierProvider),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(navigationNotifierProvider);

    ref.listen<int>(navigationNotifierProvider, (prev, next) {
      _handleNavigationChange(next);
    });

    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: _screens,
          ),
          NavBarWidget(selectedIndex: selectedIndex, onTap: _onNavBarTap),
        ],
      ),
    );
  }
}
