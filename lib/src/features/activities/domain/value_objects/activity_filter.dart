import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';

class ActivityFilter {
  final String? search;
  final int? disciplineId;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? dueBefore;
  final DateTime? dueAfter;
  final List<ActivityStatus>? statuses;

  const ActivityFilter({
    this.search,
    this.disciplineId,
    this.startDate,
    this.endDate,
    this.dueBefore,
    this.dueAfter,
    this.statuses,
  });

  ActivityFilter copyWith({
    String? search,
    int? disciplineId,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? dueBefore,
    DateTime? dueAfter,
    List<ActivityStatus>? statuses,
  }) {
    return ActivityFilter(
      search: search ?? this.search,
      disciplineId: disciplineId ?? this.disciplineId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dueBefore: dueBefore ?? this.dueBefore,
      dueAfter: dueAfter ?? this.dueAfter,
      statuses: statuses ?? this.statuses,
    );
  }
}
