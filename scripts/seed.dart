import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

import 'package:academic_planner/src/core/database/app_database.dart';
import 'package:academic_planner/src/core/logging/logger_service_impl.dart';

import 'package:academic_planner/src/data/seeds/activity/activity_seed.dart';
import 'package:academic_planner/src/data/seeds/seed.dart';
import 'package:academic_planner/src/data/seeds/seed_runner.dart';

import 'package:academic_planner/src/features/activities/data/data_source/activity_local_datasource.dart';
import 'package:academic_planner/src/features/activities/data/repositories/activity_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = LoggerServiceImpl(Logger());

  final db = await AppDatabase.instance;

  final activityRepository = ActivityRepositoryImpl(
    ActivityLocalDataSource(db),
  );

  final runner = SeedRunner(
    seeds: <Seed>[ActivitySeed(activityRepository)],
    logger: logger,
  );

  try {
    logger.info('Starting seed process...');

    await runner.run();

    logger.info('Seed completed successfully');
  } catch (err, stackTrace) {
    logger.error(
      'Error while running seed',
      error: err,
      stackTrace: stackTrace,
    );
  } finally {
    await db.close();

    logger.info('Shutting down process...');

    exit(0);
  }
}
