import 'package:academic_planner/src/features/tags/data/models/tag_model.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _baseMap() => {'name': 'important'};

void main() {
  group('TagModel.fromMap', () {
    test('populates name correctly', () {
      final model = TagModel.fromMap(_baseMap());
      expect(model.name, 'important');
    });
  });

  group('TagModel.toMap', () {
    test('produces correct map', () {
      final model = TagModel.fromMap(_baseMap());
      final map = model.toMap();
      expect(map['name'], 'important');
      expect(map.length, 1);
    });
  });

  group('TagModel fromMap → toMap round-trip', () {
    test('preserves all fields', () {
      final original = _baseMap();
      final roundTripped = TagModel.fromMap(original).toMap();
      expect(roundTripped, original);
    });
  });

  group('TagModel.fromEntity', () {
    test('maps entity fields correctly', () {
      const entity = Tag(name: 'urgent');
      final model = TagModel.fromEntity(entity);
      expect(model.name, entity.name);
    });
  });

  group('TagModel.toEntity', () {
    test('returns entity with correct name', () {
      const model = TagModel('review');
      final entity = model.toEntity();
      expect(entity.name, model.name);
    });
  });

  group('TagModel fromEntity → toEntity round-trip', () {
    test('preserves name', () {
      const original = Tag(name: 'exam');
      final roundTripped = TagModel.fromEntity(original).toEntity();
      expect(roundTripped.name, original.name);
    });
  });
}
