import 'dart:io';

import 'package:logging/logging.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:academic_planner/src/core/database/app_database.dart';
import 'package:academic_planner/src/core/seeds/seed.dart';
import 'package:academic_planner/src/core/seeds/seed_runner.dart';
import 'package:academic_planner/src/features/activities/data/data_source/activity_local_datasource.dart';
import 'package:academic_planner/src/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:academic_planner/src/features/activities/data/seeds/activity_seed.dart';

final _log = Logger('seeds.script');

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final out = record.level >= Level.SEVERE ? stderr : stdout;
    out.writeln('[${record.level.name}] ${record.loggerName}: ${record.message}');
    if (record.error != null) out.writeln('  error: ${record.error}');
    if (record.stackTrace != null) out.writeln('  stackTrace: ${record.stackTrace}');
  });

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final db = await AppDatabase.instance;

  final runner = SeedRunner(
    seeds: <Seed>[
      ActivitySeed(ActivityRepositoryImpl(ActivityLocalDataSource(db))),
    ],
  );

  try {
    _log.info('Starting seed process...');

    await runner.run();

    _log.info('Seed completed successfully');
  } catch (err, stackTrace) {
    _log.severe('Error while running seed', err, stackTrace);
  } finally {
    await db.close();

    _log.info('Shutting down process...');

    exit(0);
  }
}
