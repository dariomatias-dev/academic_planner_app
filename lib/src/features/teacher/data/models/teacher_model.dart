class TeacherFormationModel {
  final String degree;
  final String institution;
  final String period;
  final String? title;
  final String? advisor;

  const TeacherFormationModel({
    required this.degree,
    required this.institution,
    required this.period,
    this.title,
    this.advisor,
  });
}

class TeacherSpecializationModel {
  final String name;
  final String institution;
  final String period;
  final String? title;
  final String? workload;

  const TeacherSpecializationModel({
    required this.name,
    required this.institution,
    required this.period,
    this.title,
    this.workload,
  });
}

class TeacherComplementaryFormationModel {
  final String name;
  final String institution;
  final String year;
  final String workload;

  const TeacherComplementaryFormationModel({
    required this.name,
    required this.institution,
    required this.year,
    required this.workload,
  });
}

class TeacherModel {
  final int id;
  final String name;
  final String lattes;
  final List<TeacherFormationModel> academicBackground;
  final List<TeacherSpecializationModel> postGraduation;
  final List<TeacherFormationModel> postDoctorate;
  final List<TeacherComplementaryFormationModel> complementaryEducation;

  const TeacherModel({
    required this.id,
    required this.name,
    required this.lattes,
    this.academicBackground = const [],
    this.postGraduation = const [],
    this.postDoctorate = const [],
    this.complementaryEducation = const [],
  });
}
