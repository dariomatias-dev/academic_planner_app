import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/controllers/activity_controller.dart';

import 'package:academic_planner/src/core/di/database_provider.dart';

import 'package:academic_planner/src/data/datasource/activity_local_datasource.dart';
import 'package:academic_planner/src/data/repositories/activity/activity_repository_impl.dart';

import 'package:academic_planner/src/notifiers/activity_notifier.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';

final activityLocalDataSourceProvider = Provider<ActivityLocalDataSource>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);

  return ActivityLocalDataSource(db);
});

final activityRepositoryProvider = Provider<ActivityRepositoryImpl>((ref) {
  final ds = ref.watch(activityLocalDataSourceProvider);

  return ActivityRepositoryImpl(ds);
});

final activityNotifierProvider =
    AsyncNotifierProvider<ActivityNotifier, List<ActivityModel>>(
      ActivityNotifier.new,
    );

final activityControllerProvider = Provider<ActivityController>((ref) {
  final notifier = ref.read(activityNotifierProvider.notifier);

  return ActivityController(notifier);
});
