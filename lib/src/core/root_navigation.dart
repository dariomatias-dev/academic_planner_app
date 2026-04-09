import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:academic_planner/src/notifiers/navigation_notifier.dart';

import 'package:academic_planner/src/screens/activities/activities_screen.dart';
import 'package:academic_planner/src/screens/home/home_screen.dart';
import 'package:academic_planner/src/screens/my_disciplines/my_disciplines_screen.dart';
import 'package:academic_planner/src/screens/settings/settings_screen.dart';

import 'package:academic_planner/src/shared/widgets/nav_bar/nav_bar_widget.dart';

class RootNavigation extends StatefulWidget {
  const RootNavigation({super.key});

  @override
  State<RootNavigation> createState() => _RootNavigationState();
}

class _RootNavigationState extends State<RootNavigation> {
  late final PageController _pageController;
  late final NavigationNotifier _navigationNotifier;

  final _screens = <Widget>[
    const HomeScreen(),
    const MyDisciplinesScreen(showBackButton: false),
    const ActivitiesScreenWidget(),
    const SettingsScreen(),
  ];

  void _handleNavigationChange() {
    final index = _navigationNotifier.index;

    if (_pageController.hasClients && _pageController.page?.round() != index) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    _navigationNotifier.setIndex(index);
  }

  void _onNavBarTap(int index) {
    _navigationNotifier.setIndex(index);
  }

  @override
  void initState() {
    super.initState();

    _navigationNotifier = context.read<NavigationNotifier>();

    _pageController = PageController(initialPage: _navigationNotifier.index);

    _navigationNotifier.addListener(_handleNavigationChange);
  }

  @override
  void dispose() {
    _navigationNotifier.removeListener(_handleNavigationChange);
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<NavigationNotifier>().index;

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
