import 'package:flutter/material.dart';

import 'package:academic_planner/src/screens/home/home_screen.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Academic Planner',
      routes: {'/': (_) => HomeScreen()},
    );
  }
}
