import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/core/logging/logger_provider.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/view_models/activity_view_model.dart';

class ActivityNotifier extends AsyncNotifier<void> {
  late final ActivityViewModel _viewModel;

  @override
  Future<void> build() async {
    final repository = ref.read(activityRepositoryProvider);
    final logger = ref.read(loggerProvider);

    _viewModel = ActivityViewModel(repository, logger);
  }

  Future<Result<void>> add(Activity activity) async {
    final result = await _viewModel.create(activity);

    if (result is Success) {
      ref.read(activityStatsNotifierProvider.notifier).refresh();
    }

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
    final result = await _viewModel.update(activity);

    if (result is Success) {
      ref.read(activityStatsNotifierProvider.notifier).refresh();
    }

    return result;
  }

  Future<Result<void>> delete(String id) async {
    final result = await _viewModel.delete(id);

    if (result is Success) {
      ref.read(activityStatsNotifierProvider.notifier).refresh();
    }

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
