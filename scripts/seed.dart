import 'dart:io';

import 'package:academic_planner/src/core/database/app_database.dart';
import 'package:academic_planner/src/core/logging/app_logger.dart';
import 'package:academic_planner/src/core/seeds/seed.dart';
import 'package:academic_planner/src/core/seeds/seed_runner.dart';
import 'package:academic_planner/src/features/activities/data/seeds/activity_seed.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final _log = AppLogger('seeds.script');

Future<void> main() async {
  configureLogging();

  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;

  final db = await AppDatabase.instance;

  final runner = SeedRunner(
    seeds: <Seed>[
      ActivitySeed(db),
    ],
  );

  try {
    _log.info('Starting seed process...');

    await runner.run();

    _log.info('Seed completed successfully');
  } on Exception catch (err, stackTrace) {
    _log.severe('Error while running seed', err, stackTrace);
  } finally {
    await db.close();

    _log.info('Shutting down process...');

    exit(0);
  }
}
