import 'package:academic_planner/src/features/categories/data/models/category_model.dart';
import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _baseMap() => {'name': 'Mathematics'};

void main() {
  group('CategoryModel.fromMap', () {
    test('populates name correctly', () {
      final model = CategoryModel.fromMap(_baseMap());
      expect(model.name, 'Mathematics');
    });
  });

  group('CategoryModel.toMap', () {
    test('produces correct map', () {
      final model = CategoryModel.fromMap(_baseMap());
      final map = model.toMap();
      expect(map['name'], 'Mathematics');
      expect(map.length, 1);
    });
  });

  group('CategoryModel fromMap → toMap round-trip', () {
    test('preserves all fields', () {
      final original = _baseMap();
      final roundTripped = CategoryModel.fromMap(original).toMap();
      expect(roundTripped, original);
    });
  });

  group('CategoryModel.fromEntity', () {
    test('maps entity fields correctly', () {
      const entity = Category(name: 'Science');
      final model = CategoryModel.fromEntity(entity);
      expect(model.name, entity.name);
    });
  });

  group('CategoryModel.toEntity', () {
    test('returns entity with correct name', () {
      const model = CategoryModel('History');
      final entity = model.toEntity();
      expect(entity.name, model.name);
    });
  });

  group('CategoryModel fromEntity → toEntity round-trip', () {
    test('preserves name', () {
      const original = Category(name: 'Physics');
      final roundTripped = CategoryModel.fromEntity(original).toEntity();
      expect(roundTripped.name, original.name);
    });
  });
}
