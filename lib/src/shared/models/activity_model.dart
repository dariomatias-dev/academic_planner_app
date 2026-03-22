class ActivityModel {
  final String title;
  final DateTime deadline;
  final int disciplineId;
  final String priority;
  final bool isCompleted;

  ActivityModel({
    required this.title,
    required this.deadline,
    required this.disciplineId,
    required this.priority,
    this.isCompleted = false,
  });
}
