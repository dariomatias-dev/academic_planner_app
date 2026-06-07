import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';

class AgendaState {
  AgendaState({
    this.activities = const [],
    DateTime? displayDate,
    DateTime? selectedDate,
    this.filter,
  }) : displayDate = displayDate ?? DateTime.now(),
       selectedDate = selectedDate ?? DateTime.now();

  final List<Activity> activities;
  final DateTime displayDate;
  final DateTime selectedDate;
  final ActivityFilter? filter;

  AgendaState copyWith({
    List<Activity>? activities,
    DateTime? displayDate,
    DateTime? selectedDate,
    ActivityFilter? filter,
    bool clearFilter = false,
  }) {
    return AgendaState(
      activities: activities ?? this.activities,
      displayDate: displayDate ?? this.displayDate,
      selectedDate: selectedDate ?? this.selectedDate,
      filter: clearFilter ? null : (filter ?? this.filter),
    );
  }
}
