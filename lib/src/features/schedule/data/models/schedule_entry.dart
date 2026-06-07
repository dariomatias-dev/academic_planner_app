class ScheduleEntry {
  const ScheduleEntry({
    required this.disciplineId,
    required this.day,
    required this.time,
    required this.teacherId,
  });

  final int disciplineId;
  final int day;
  final String time;
  final int teacherId;
}
