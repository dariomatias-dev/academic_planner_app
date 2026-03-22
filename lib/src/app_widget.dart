import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/root_navigation.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Academic Planner',
      initialRoute: '/',
      routes: <String, WidgetBuilder>{'/': (context) => const RootNavigation()},
    );
  }
}
