class ActivityStats {
  const ActivityStats({
    required this.total,
    required this.active,
    required this.completed,
    required this.urgent,
    required this.progress,
  });

  final int total;
  final int active;
  final int completed;
  final int urgent;
  final double progress;
}
