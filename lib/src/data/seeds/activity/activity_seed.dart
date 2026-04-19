import 'package:academic_planner/src/data/seeds/activity/activity_seed_data.dart';
import 'package:academic_planner/src/data/seeds/seed.dart';

import 'package:academic_planner/src/features/activities/data/repositories/activity_repository_impl.dart';

class ActivitySeed implements Seed {
  final ActivityRepositoryImpl repository;

  ActivitySeed(this.repository);

  @override
  String get name => 'activity_seed';

  @override
  Future<void> run() async {
    for (final activity in activitySeedData) {
      await repository.add(activity);
    }
  }
}
