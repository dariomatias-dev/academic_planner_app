class Discipline {
  Discipline({
    required this.id,
    required this.acronym,
    required this.name,
    required this.description,
    required this.period,
    required this.type,
    required this.workload,
    required this.weeklyHours,
    required this.responsibleProfessorId,
    required this.prerequisites,
    required this.prerequisiteFor,
    required this.coursePlan,
  });

  final int id;
  final String acronym;
  final String name;
  final String description;
  final int period;
  final String type;
  final int workload;
  final int weeklyHours;
  final int responsibleProfessorId;
  final List<int> prerequisites;
  final List<int> prerequisiteFor;
  final String coursePlan;
}
