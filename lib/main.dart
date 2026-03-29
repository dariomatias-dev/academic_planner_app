import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:academic_planner/src/app_widget.dart';

import 'package:academic_planner/src/core/theme/theme_controller.dart';

void main() {
  final themeController = ThemeController();

  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider(create: (_) => themeController),
      ],
      child: AppWidget(),
    ),
  );
}
