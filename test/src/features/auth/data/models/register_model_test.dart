import 'package:academic_planner/src/features/auth/data/models/register_model.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _baseMap() => {
  'name': 'Alice',
  'email': 'alice@example.com',
  'password': 'strongpass',
};

void main() {
  group('RegisterModel.fromMap', () {
    test('populates all fields correctly', () {
      final model = RegisterModel.fromMap(_baseMap());
      expect(model.name, 'Alice');
      expect(model.email, 'alice@example.com');
      expect(model.password, 'strongpass');
    });
  });

  group('RegisterModel.toMap', () {
    test('produces correct map', () {
      final model = RegisterModel.fromMap(_baseMap());
      final map = model.toMap();
      expect(map['name'], 'Alice');
      expect(map['email'], 'alice@example.com');
      expect(map['password'], 'strongpass');
      expect(map.length, 3);
    });
  });

  group('RegisterModel fromMap → toMap round-trip', () {
    test('preserves all fields', () {
      final original = _baseMap();
      final roundTripped = RegisterModel.fromMap(original).toMap();
      expect(roundTripped, original);
    });
  });

  group('RegisterModel.fromEntity', () {
    test('maps entity fields correctly', () {
      final entity = RegisterEntity(
        name: 'Bob',
        email: 'bob@example.com',
        password: 'pass789',
      );
      final model = RegisterModel.fromEntity(entity);
      expect(model.name, entity.name);
      expect(model.email, entity.email);
      expect(model.password, entity.password);
    });
  });
}
