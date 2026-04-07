import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/data/filters/activity_filter.dart';

import 'package:academic_planner/src/notifiers/activity_notifier.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';

class ActivityController {
  final ActivityNotifier notifier;

  ActivityController(this.notifier);

  Future<Result<void>> createActivity({
    required String title,
    required String description,
    String? notes,
    required int disciplineId,
    DateTime? dueDate,
    String? category,
    required List<String> tags,
    required List<TimeOfDay> reminders,
    ActivityStatus? status,
  }) async {
    final activity = ActivityModel(
      id: const Uuid().v7(),
      title: title,
      description: description,
      notes: notes,
      disciplineId: disciplineId,
      dueDate: dueDate,
      category: category,
      tags: tags,
      reminders: reminders,
      status: status,
    );

    return await notifier.addActivity(activity);
  }

  Future<Result<List<ActivityModel>>> getActivities({
    ActivityFilter? filter,
  }) async {
    return await notifier.getActivities(filter: filter);
  }

  Future<Result<ActivityModel?>> getActivityById(String id) async {
    return await notifier.getActivityById(id);
  }

  Future<Result<void>> editActivity(ActivityModel activity) async {
    final updatedActivity = activity.copyWith(updatedAt: DateTime.now());

    return await notifier.updateActivity(updatedActivity);
  }

  Future<Result<void>> removeActivity(String id) async {
    return await notifier.deleteActivity(id);
  }
}
