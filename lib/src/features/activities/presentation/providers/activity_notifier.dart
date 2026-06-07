import 'dart:async';

import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class ActivityNotifier extends AsyncNotifier<void> {
  static final _log = Logger('activities.ActivityNotifier');

  late final ActivityViewModel _viewModel;

  @override
  Future<void> build() async {
    final repository = ref.read(activityRepositoryProvider);

    _viewModel = ActivityViewModel(repository);
  }

  Future<Result<void>> add(Activity activity) async {
    state = const AsyncLoading();

    final result = await _viewModel.create(activity);

    state = result.fold(
      onSuccess: (_) {
        unawaited(ref.read(activityStatsNotifierProvider.notifier).refresh());

        return const AsyncData(null);
      },
      onFailure: (f) {
        _log.warning('add failed: ${f.message}');

        return AsyncError(f, StackTrace.current);
      },
    );

    return result;
  }

  Future<Result<List<Activity>>> getAll({
    ActivityFilter? filter,
    Pagination? pagination,
  }) {
    return _viewModel.getAll(filter: filter, pagination: pagination);
  }

  Future<Result<int>> count({ActivityFilter? filter}) {
    return _viewModel.count(filter: filter);
  }

  Future<Result<Activity?>> getById(String id) {
    return _viewModel.getById(id);
  }

  Future<Result<void>> edit(Activity activity) async {
    state = const AsyncLoading();

    final result = await _viewModel.update(activity);

    state = result.fold(
      onSuccess: (_) {
        unawaited(ref.read(activityStatsNotifierProvider.notifier).refresh());

        return const AsyncData(null);
      },
      onFailure: (f) {
        _log.warning('edit failed: ${f.message}');

        return AsyncError(f, StackTrace.current);
      },
    );

    return result;
  }

  Future<Result<void>> delete(String id) async {
    state = const AsyncLoading();

    final result = await _viewModel.delete(id);

    state = result.fold(
      onSuccess: (_) {
        unawaited(ref.read(activityStatsNotifierProvider.notifier).refresh());

        return const AsyncData(null);
      },
      onFailure: (f) {
        _log.warning('delete failed: ${f.message}');

        return AsyncError(f, StackTrace.current);
      },
    );

    return result;
  }

  Activity createNew({
    required String title,
    required String description,
    required int disciplineId,
    required List<String> tags,
    required List<TimeOfDay> reminders,
    required ActivityStatus status,
    String? category,
    DateTime? dueDate,
    String? notes,
  }) {
    return _viewModel.createNew(
      title: title,
      description: description,
      disciplineId: disciplineId,
      tags: tags,
      reminders: reminders,
      status: status,
      category: category,
      dueDate: dueDate,
      notes: notes,
    );
  }
}
