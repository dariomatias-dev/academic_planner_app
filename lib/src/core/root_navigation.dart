import 'package:flutter/material.dart';

import 'package:academic_planner/src/screens/activities/activities_screen.dart';
import 'package:academic_planner/src/screens/disciplines/disciplines_screen.dart';
import 'package:academic_planner/src/screens/home/home_screen.dart';

import 'package:academic_planner/src/shared/widgets/nav_bar/nav_bar_widget.dart';

class RootNavigation extends StatefulWidget {
  const RootNavigation({super.key});

  @override
  State<RootNavigation> createState() => RootNavigationState();
}

class RootNavigationState extends State<RootNavigation> {
  int selectedIndex = 0;

  final screens = <Widget>[
    const HomeScreen(),
    const DisciplinesScreen(),
    const ActivitiesScreenWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          IndexedStack(index: selectedIndex, children: screens),
          NavBarWidget(
            selectedIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
