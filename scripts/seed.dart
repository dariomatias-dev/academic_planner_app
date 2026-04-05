import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

import 'package:academic_planner/src/core/database/app_database.dart';

import 'package:academic_planner/src/data/seeds/seed.dart';
import 'package:academic_planner/src/data/seeds/seed_runner.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = Logger();

  final db = await AppDatabase.instance;

  final runner = SeedRunner(
    seeds: <Seed>[],
    logger: logger,
  );

  try {
    logger.i('Starting seed process...');

    await runner.run();

    logger.i('Seed completed successfully');
  } catch (err, stackTrace) {
    logger.e('Error while running seed', error: err, stackTrace: stackTrace);
  } finally {
    await db.close();

    logger.i('Shutting down process...');

    exit(0);
  }
}
