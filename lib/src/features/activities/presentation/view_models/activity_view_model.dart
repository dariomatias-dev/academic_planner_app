import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';

class ActivityViewModel {
  static final _log = Logger('activities.ActivityViewModel');

  final ActivityRepository repository;

  ActivityViewModel(this.repository);

  Future<Result<void>> create(Activity activity) async {
    _log.info('createActivity started: ${activity.title}');

    final result = await repository.add(activity);

    _log.info('createActivity success: ${activity.title}');

    return result;
  }

  Future<Result<List<Activity>>> getAll({
    ActivityFilter? filter,
    Pagination? pagination,
  }) async {
    _log.info('getActivities started');

    final result = await repository.getAll(
      filter: filter,
      pagination: pagination,
    );

    _log.info('getActivities success');

    return result;
  }

  Future<Result<int>> count({ActivityFilter? filter}) async {
    _log.info('countActivities started');

    final result = await repository.count(filter: filter);

    _log.info('countActivities success');

    return result;
  }

  Future<Result<Activity?>> getById(String id) async {
    _log.info('getById started: $id');

    final result = await repository.getById(id);

    _log.info('getById success: $id');

    return result;
  }

  Future<Result<void>> update(Activity activity) async {
    _log.info('update started: ${activity.id}');

    final updated = activity.copyWith(updatedAt: DateTime.now());
    final result = await repository.update(updated);

    _log.info('update success: ${activity.id}');

    return result;
  }

  Future<Result<void>> delete(String id) async {
    _log.info('delete started: $id');

    final result = await repository.delete(id);

    _log.info('delete success: $id');

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
    final now = DateTime.now();

    _log.info('createNew activity: $title');

    return Activity(
      id: const Uuid().v7(),
      title: title,
      description: description,
      disciplineId: disciplineId,
      tags: tags,
      reminders: reminders,
      status: status,
      category: category,
      dueDate: dueDate,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );
  }
}
