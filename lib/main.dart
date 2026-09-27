import 'dart:async';

import 'package:academic_planner/firebase_options.dart';
import 'package:academic_planner/src/academic_planner_app.dart';
import 'package:academic_planner/src/core/database/app_database.dart';
import 'package:academic_planner/src/core/di/database_provider.dart';
import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';
import 'package:academic_planner/src/core/errors/error_boundary.dart';
import 'package:academic_planner/src/core/errors/logging_error_reporter.dart';
import 'package:academic_planner/src/core/logging/app_logger.dart';
import 'package:academic_planner/src/core/seeds/seed_initializer.dart';
import 'package:academic_planner/src/core/startup_failure_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _log = AppLogger('main');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureLogging();
  configureErrorBoundary(LoggingErrorReporter());

  await initializeDateFormatting('pt_BR');

  await _bootstrap();
}

/// Initializes Firebase and the local database, then runs the app. On
/// failure, runs [StartupFailureApp] instead, whose retry button re-runs
/// this same function.
Future<void> _bootstrap() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await GoogleSignIn.instance.initialize();

    final prefs = await SharedPreferences.getInstance();

    final appDatabase = await AppDatabase.instance;

    await runDevSeeds(appDatabase);

    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          appDatabaseProvider.overrideWithValue(appDatabase),
        ],
        child: const AcademicPlannerApp(),
      ),
    );
  } on Exception catch (err, stackTrace) {
    _log.severe('Startup failed', err, stackTrace);

    runApp(StartupFailureApp(onRetry: () => unawaited(_bootstrap())));
  }
}
