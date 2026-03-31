import 'package:academic_planner/src/shared/models/teacher_model.dart';

final defaultTeacher = TeacherModel(id: 0, name: "Professor não definido");

TeacherModel getTeacherById(int id, List<TeacherModel> teachers) {
  return teachers.firstWhere((t) => t.id == id, orElse: () => defaultTeacher);
}
