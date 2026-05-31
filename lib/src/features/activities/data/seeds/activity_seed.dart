import 'package:academic_planner/src/core/seeds/seed.dart';

import 'package:academic_planner/src/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:academic_planner/src/features/activities/data/seeds/activity_seed_data.dart';

class ActivitySeed implements Seed {
  final ActivityRepositoryImpl repository;

  ActivitySeed(this.repository);

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
