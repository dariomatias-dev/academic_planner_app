import 'package:academic_planner/src/shared/models/activity_model.dart';

class ActivityFilter {
  final String? search;
  final int? disciplineId;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<ActivityStatus>? statuses;

  const ActivityFilter({
    this.search,
    this.disciplineId,
    this.startDate,
    this.endDate,
    this.statuses,
  });

  ActivityFilter copyWith({
    String? search,
    int? disciplineId,
    DateTime? startDate,
    DateTime? endDate,
    List<ActivityStatus>? statuses,
  }) {
    return ActivityFilter(
      search: search ?? this.search,
      disciplineId: disciplineId ?? this.disciplineId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      statuses: statuses ?? this.statuses,
    );
  }
}
