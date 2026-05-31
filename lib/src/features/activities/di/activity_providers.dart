import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/di/database_provider.dart';

import 'package:academic_planner/src/features/activities/data/data_source/activity_local_datasource.dart';
import 'package:academic_planner/src/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity_stats.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_filter_notifier.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_notifier.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_stats_notifier.dart';

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

final activityStatsNotifierProvider =
    AsyncNotifierProvider<ActivityStatsNotifier, ActivityStats>(
      ActivityStatsNotifier.new,
    );

final activityCountProvider = FutureProvider.family<int, ActivityFilter?>((
  ref,
  filter,
) async {
  ref.watch(activityNotifierProvider);

  final result = await ref
      .read(activityNotifierProvider.notifier)
      .count(filter: filter);

  return result.fold(onSuccess: (count) => count, onFailure: (_) => 0);
});
