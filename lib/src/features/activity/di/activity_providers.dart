import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/di/database_provider.dart';

import 'package:academic_planner/src/features/activity/data/data_source/activity_local_datasource.dart';
import 'package:academic_planner/src/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:academic_planner/src/features/activity/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activity/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/activity/presentation/providers/activity_filter_notifier.dart';
import 'package:academic_planner/src/features/activity/presentation/providers/activity_notifier.dart';

final activityDatasourceProvider = Provider<ActivityLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);

  return ActivityLocalDataSource(db);
});

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final datasource = ref.watch(activityDatasourceProvider);

  return ActivityRepositoryImpl(datasource);
});

final activityNotifierProvider = AsyncNotifierProvider<ActivityNotifier, void>(
  (() {
    return ActivityNotifier();
  }),
);

final activityFilterNotifierProvider =
    NotifierProvider<ActivityFilterNotifier, ActivityFilter>(
      ActivityFilterNotifier.new,
    );
