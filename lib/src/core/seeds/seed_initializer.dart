import 'package:academic_planner/src/core/seeds/seed_runner.dart';
import 'package:academic_planner/src/features/activities/data/data_source/activity_local_datasource.dart';
import 'package:academic_planner/src/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:academic_planner/src/features/activities/data/seeds/activity_seed.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

// To run seeds: flutter run --dart-define=SEED_ENABLED=true
// Seeds never execute in release builds regardless of the flag.
const _seedEnabled = bool.fromEnvironment('SEED_ENABLED');

Future<void> runDevSeeds(Database db) async {
  if (!kDebugMode || !_seedEnabled) return;

  await SeedRunner(
    seeds: [
      ActivitySeed(ActivityRepositoryImpl(ActivityLocalDataSource(db))),
    ],
  ).run();
}
