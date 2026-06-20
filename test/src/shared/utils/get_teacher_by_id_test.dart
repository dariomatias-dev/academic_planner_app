import 'package:academic_planner/src/features/teacher/data/models/teacher_model.dart';
import 'package:academic_planner/src/shared/utils/get_teacher_by_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const teachers = [
    TeacherModel(id: 1, name: 'Alice', lattes: 'lattes-1'),
    TeacherModel(id: 2, name: 'Bob', lattes: 'lattes-2'),
  ];

  group('getTeacherById', () {
    test('found id → returns the matching teacher', () {
      final teacher = getTeacherById(2, teachers);

      expect(teacher.id, 2);
      expect(teacher.name, 'Bob');
    });

    test('missing id → returns the default teacher', () {
      final teacher = getTeacherById(99, teachers);

      expect(teacher, defaultTeacher);
      expect(teacher.id, 0);
      expect(teacher.name, 'Professor não definido');
    });

    test('empty list → returns the default teacher', () {
      final teacher = getTeacherById(1, const []);

      expect(teacher, defaultTeacher);
    });
  });
}
