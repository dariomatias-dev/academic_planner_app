class TeacherFormationModel {
  const TeacherFormationModel({
    required this.degree,
    required this.institution,
    required this.period,
    this.title,
    this.advisor,
  });

  final String degree;
  final String institution;
  final String period;
  final String? title;
  final String? advisor;
}

class TeacherSpecializationModel {
  const TeacherSpecializationModel({
    required this.name,
    required this.institution,
    required this.period,
    this.title,
    this.workload,
  });

  final String name;
  final String institution;
  final String period;
  final String? title;
  final String? workload;
}

class TeacherComplementaryFormationModel {
  const TeacherComplementaryFormationModel({
    required this.name,
    required this.institution,
    required this.year,
    required this.workload,
  });

  final String name;
  final String institution;
  final String year;
  final String workload;
}

class TeacherModel {
  const TeacherModel({
    required this.id,
    required this.name,
    required this.lattes,
    this.academicBackground = const [],
    this.postGraduation = const [],
    this.postDoctorate = const [],
    this.complementaryEducation = const [],
  });

  final int id;
  final String name;
  final String lattes;
  final List<TeacherFormationModel> academicBackground;
  final List<TeacherSpecializationModel> postGraduation;
  final List<TeacherFormationModel> postDoctorate;
  final List<TeacherComplementaryFormationModel> complementaryEducation;
}
