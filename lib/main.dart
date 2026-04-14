import 'package:academic_planner/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:academic_planner/src/app_widget.dart';

import 'package:academic_planner/src/controllers/activity_controller.dart';

import 'package:academic_planner/src/core/database/app_database.dart';
import 'package:academic_planner/src/core/services/shared_preferences_service.dart';
import 'package:academic_planner/src/core/theme/theme_notifier.dart';

import 'package:academic_planner/src/data/datasource/activity_local_datasource.dart';
import 'package:academic_planner/src/data/repositories/activity/activity_repository_impl.dart';

import 'package:academic_planner/src/notifiers/activity_filter_notifier.dart';
import 'package:academic_planner/src/notifiers/activity_notifier.dart';
import 'package:academic_planner/src/notifiers/navigation_notifier.dart';
import 'package:academic_planner/src/notifiers/user_disciplines_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final prefsService = SharedPreferencesService(prefs);
  final themeNotifier = ThemeNotifier(prefsService);

  final appDatabase = await AppDatabase.instance;

  final activityLocalDataSource = ActivityLocalDataSource(appDatabase);
  final activityRepository = ActivityRepositoryImpl(activityLocalDataSource);
  final activityNotifier = ActivityNotifier(activityRepository);

  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider(create: (_) => ActivityFilterNotifier()),
        ChangeNotifierProvider<NavigationNotifier>(
          create: (_) => NavigationNotifier(),
        ),
        Provider<SharedPreferencesService>(create: (_) => prefsService),
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => themeNotifier),
        ChangeNotifierProvider<UserDisciplinesNotifier>(
          create: (_) => UserDisciplinesNotifier(prefsService),
        ),
        Provider<ActivityController>(
          create: (_) => ActivityController(activityNotifier),
        ),
      ],
      child: const AppWidget(),
    ),
  );
}
