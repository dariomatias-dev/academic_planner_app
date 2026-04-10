import 'package:academic_planner/src/shared/models/activity_model.dart';

class ActivityFilter {
  final String? search;
  final int? disciplineId;
  final DateTime? startDate;
  final DateTime? endDate;
  final ActivityStatus? status;

  const ActivityFilter({
    this.search,
    this.disciplineId,
    this.startDate,
    this.endDate,
    this.status,
  });

  ActivityFilter copyWith({
    String? search,
    int? disciplineId,
    DateTime? startDate,
    DateTime? endDate,
    ActivityStatus? status,
  }) {
    return ActivityFilter(
      search: search ?? this.search,
      disciplineId: disciplineId ?? this.disciplineId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
    );
  }
}
