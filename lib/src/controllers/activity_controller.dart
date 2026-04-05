import 'package:uuid/uuid.dart';

import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/notifiers/activity_notifier.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';

class ActivityController {
  final ActivityNotifier notifier;

  ActivityController(this.notifier);

  Future<Result<void>> init() async {
    final result = await notifier.getActivities();

    return result.fold(
      onSuccess: (_) => const Success(null),
      onFailure: (f) => FailureResult(f),
    );
  }

  Future<Result<void>> createActivity(ActivityModel activity) async {
    return await notifier.addActivity(activity.copyWith(id: const Uuid().v7()));
  }

  List<ActivityModel> getActivities() {
    return notifier.activities;
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
