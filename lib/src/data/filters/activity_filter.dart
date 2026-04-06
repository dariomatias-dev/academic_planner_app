class ActivityFilter {
  final String? search;
  final int? disciplineId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;

  const ActivityFilter({
    this.search,
    this.disciplineId,
    this.startDate,
    this.endDate,
    this.status,
  });
}
