import 'package:academic_planner/src/features/users/data/models/user_model.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

final _ts = Timestamp.fromDate(DateTime.parse('2024-01-01T00:00:00.000'));

Map<String, dynamic> _baseMap({
  String role = 'student',
  bool withTimestamps = true,
}) => {
  'id': 'user-1',
  'email': 'a@b.com',
  'name': 'Alice',
  'role': role,
  'created_at': withTimestamps ? _ts : null,
  'updated_at': withTimestamps ? _ts : null,
};

void main() {
  group('UserModel.fromMap — role parsing', () {
    test('admin → UserRole.admin', () {
      final model = UserModel.fromMap(_baseMap(role: 'admin'));
      expect(model.role, UserRole.admin);
    });

    test('teacher → UserRole.teacher', () {
      final model = UserModel.fromMap(_baseMap(role: 'teacher'));
      expect(model.role, UserRole.teacher);
    });

    test('student → UserRole.student', () {
      final model = UserModel.fromMap(_baseMap());
      expect(model.role, UserRole.student);
    });

    test('unknown value → UserRole.student', () {
      final model = UserModel.fromMap(_baseMap(role: 'unknown'));
      expect(model.role, UserRole.student);
    });
  });

  group('UserModel.fromMap — timestamps', () {
    test('Timestamp values → parsed to DateTime', () {
      final model = UserModel.fromMap(_baseMap());
      expect(
        model.createdAt,
        DateTime.parse('2024-01-01T00:00:00.000'),
      );
      expect(
        model.updatedAt,
        DateTime.parse('2024-01-01T00:00:00.000'),
      );
    });

    test('non-Timestamp values → fallback to DateTime.now()', () {
      final before = DateTime.now();
      final model = UserModel.fromMap(_baseMap(withTimestamps: false));
      final after = DateTime.now();

      expect(
        model.createdAt.millisecondsSinceEpoch,
        inInclusiveRange(
          before.millisecondsSinceEpoch,
          after.millisecondsSinceEpoch,
        ),
      );
      expect(
        model.updatedAt.millisecondsSinceEpoch,
        inInclusiveRange(
          before.millisecondsSinceEpoch,
          after.millisecondsSinceEpoch,
        ),
      );
    });
  });

  group('UserModel.toMap', () {
    test('fields mapped correctly', () {
      final model = UserModel(
        id: 'user-1',
        email: 'a@b.com',
        name: 'Alice',
        role: UserRole.teacher,
        createdAt: DateTime.parse('2024-01-01T00:00:00.000'),
        updatedAt: DateTime.parse('2024-01-01T00:00:00.000'),
      );

      final map = model.toMap();

      expect(map['id'], 'user-1');
      expect(map['email'], 'a@b.com');
      expect(map['name'], 'Alice');
      expect(map['role'], 'teacher');
      expect(map['created_at'], isA<Timestamp>());
      expect(map['updated_at'], isA<Timestamp>());
      expect(
        (map['created_at'] as Timestamp).toDate(),
        DateTime.parse('2024-01-01T00:00:00.000'),
      );
    });

    test('role.name used as string value', () {
      final modelAdmin = UserModel(
        id: 'u',
        email: 'e',
        name: 'n',
        role: UserRole.admin,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(modelAdmin.toMap()['role'], 'admin');
    });
  });
}
