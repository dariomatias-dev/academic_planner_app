import 'package:flutter/material.dart';

import 'package:academic_planner/src/screens/activities/activities_screen.dart';
import 'package:academic_planner/src/screens/home/home_screen.dart';
import 'package:academic_planner/src/screens/my_disciplines/my_disciplines_screen.dart';
import 'package:academic_planner/src/screens/settings/settings_screen.dart';

import 'package:academic_planner/src/shared/widgets/nav_bar/nav_bar_widget.dart';

class RootNavigation extends StatefulWidget {
  const RootNavigation({super.key});

  @override
  State<RootNavigation> createState() => RootNavigationState();
}

class RootNavigationState extends State<RootNavigation> {
  late final _pageController = PageController(initialPage: selectedIndex);

  int selectedIndex = 0;

  final _screens = <Widget>[
    const HomeScreen(),
    const MyDisciplinesScreen(showBackButton: false),
    const ActivitiesScreenWidget(),
    const SettingsScreen(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onNavBarTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
