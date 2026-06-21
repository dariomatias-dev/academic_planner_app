class TeacherFormation {
  const TeacherFormation({
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

class TeacherSpecialization {
  const TeacherSpecialization({
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

class TeacherComplementaryFormation {
  const TeacherComplementaryFormation({
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

class Teacher {
  const Teacher({
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
  final List<TeacherFormation> academicBackground;
  final List<TeacherSpecialization> postGraduation;
  final List<TeacherFormation> postDoctorate;
  final List<TeacherComplementaryFormation> complementaryEducation;
}
