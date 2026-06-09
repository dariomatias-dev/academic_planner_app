import 'package:academic_planner/src/features/auth/data/models/login_model.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _baseMap() => {
  'email': 'user@example.com',
  'password': 'secret123',
};

void main() {
  group('LoginModel.fromMap', () {
    test('populates all fields correctly', () {
      final model = LoginModel.fromMap(_baseMap());
      expect(model.email, 'user@example.com');
      expect(model.password, 'secret123');
    });
  });

  group('LoginModel.toMap', () {
    test('produces correct map', () {
      final model = LoginModel.fromMap(_baseMap());
      final map = model.toMap();
      expect(map['email'], 'user@example.com');
      expect(map['password'], 'secret123');
      expect(map.length, 2);
    });
  });

  group('LoginModel fromMap → toMap round-trip', () {
    test('preserves all fields', () {
      final original = _baseMap();
      final roundTripped = LoginModel.fromMap(original).toMap();
      expect(roundTripped, original);
    });
  });

  group('LoginModel.fromEntity', () {
    test('maps entity fields correctly', () {
      final entity = LoginEntity(
        email: 'admin@example.com',
        password: 'pass456',
      );
      final model = LoginModel.fromEntity(entity);
      expect(model.email, entity.email);
      expect(model.password, entity.password);
    });
  });
}
