import 'package:academic_planner/src/features/teacher/domain/entities/teacher.dart';

const defaultTeacher = Teacher(
  id: 0,
  name: 'Professor não definido',
  lattes: '',
);

Teacher getTeacherById(int id, List<Teacher> teachers) {
  return teachers.firstWhere((t) => t.id == id, orElse: () => defaultTeacher);
}
