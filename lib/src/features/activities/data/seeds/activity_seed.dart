import 'package:academic_planner/src/core/seeds/seed.dart';
import 'package:academic_planner/src/features/activities/data/data_source/activity_local_datasource.dart';
import 'package:academic_planner/src/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:academic_planner/src/features/activities/data/seeds/activity_seed_data.dart';
import 'package:sqflite/sqflite.dart';

class ActivitySeed implements Seed {
  ActivitySeed(Database db)
    : repository = ActivityRepositoryImpl(ActivityLocalDataSource(db));

  final ActivityRepositoryImpl repository;

  @override
  String get name => 'activity_seed';

  @override
  Future<void> run() async {
    await repository.deleteAll();

    for (final activity in activitySeedData) {
      await repository.add(activity);
    }
  }
}
