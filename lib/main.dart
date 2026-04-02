import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:academic_planner/src/app_widget.dart';

import 'package:academic_planner/src/core/theme/theme_controller.dart';
import 'package:academic_planner/src/core/services/shared_preferences_service.dart';

import 'package:academic_planner/src/notifiers/user_disciplines_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);

  final prefs = await SharedPreferences.getInstance();

  final prefsService = SharedPreferencesService(prefs);

  final themeController = ThemeController(prefsService);

  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        Provider<SharedPreferencesService>(create: (_) => prefsService),
        ChangeNotifierProvider<UserDisciplinesNotifier>(
          create: (_) => UserDisciplinesNotifier(prefsService),
        ),
        ChangeNotifierProvider<ThemeController>(create: (_) => themeController),
      ],
      child: const AppWidget(),
    ),
  );
}
