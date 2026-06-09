import 'package:academic_planner/src/features/notes/data/models/note_model.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _baseMap() => {
  'id': 'note-1',
  'title': 'Calculus I',
  'content': 'Derivatives and integrals',
  'disciplineId': 5,
  'createdAt': '2024-03-01T08:00:00.000',
  'updatedAt': '2024-03-02T10:00:00.000',
};

void main() {
  group('NoteModel.fromMap', () {
    test('populates all fields correctly', () {
      final model = NoteModel.fromMap(_baseMap());
      expect(model.id, 'note-1');
      expect(model.title, 'Calculus I');
      expect(model.content, 'Derivatives and integrals');
      expect(model.disciplineId, 5);
      expect(model.createdAt, DateTime.parse('2024-03-01T08:00:00.000'));
      expect(model.updatedAt, DateTime.parse('2024-03-02T10:00:00.000'));
    });
  });

  group('NoteModel.toMap', () {
    test('produces correct map', () {
      final model = NoteModel.fromMap(_baseMap());
      final map = model.toMap();
      expect(map['id'], 'note-1');
      expect(map['title'], 'Calculus I');
      expect(map['content'], 'Derivatives and integrals');
      expect(map['disciplineId'], 5);
      expect(map['createdAt'], '2024-03-01T08:00:00.000');
      expect(map['updatedAt'], '2024-03-02T10:00:00.000');
    });
  });

  group('NoteModel fromMap → toMap round-trip', () {
    test('preserves all fields', () {
      final original = _baseMap();
      final roundTripped = NoteModel.fromMap(original).toMap();
      expect(roundTripped, original);
    });
  });

  group('NoteModel.fromEntity', () {
    test('maps entity fields correctly', () {
      final note = Note(
        id: 'n1',
        title: 'Physics',
        content: 'Newton laws',
        disciplineId: 3,
        createdAt: DateTime.parse('2024-01-10T00:00:00.000'),
        updatedAt: DateTime.parse('2024-01-11T00:00:00.000'),
      );
      final model = NoteModel.fromEntity(note);
      expect(model.id, note.id);
      expect(model.title, note.title);
      expect(model.content, note.content);
      expect(model.disciplineId, note.disciplineId);
      expect(model.createdAt, note.createdAt);
      expect(model.updatedAt, note.updatedAt);
    });
  });

  group('NoteModel.toEntity', () {
    test('returns entity with all fields', () {
      final model = NoteModel.fromMap(_baseMap());
      final entity = model.toEntity();
      expect(entity.id, model.id);
      expect(entity.title, model.title);
      expect(entity.content, model.content);
      expect(entity.disciplineId, model.disciplineId);
      expect(entity.createdAt, model.createdAt);
      expect(entity.updatedAt, model.updatedAt);
    });
  });

  group('NoteModel fromEntity → toEntity round-trip', () {
    test('preserves all fields', () {
      final original = Note(
        id: 'rt-1',
        title: 'Chemistry',
        content: 'Periodic table',
        disciplineId: 7,
        createdAt: DateTime.parse('2024-05-01T00:00:00.000'),
        updatedAt: DateTime.parse('2024-05-02T00:00:00.000'),
      );
      final roundTripped = NoteModel.fromEntity(original).toEntity();
      expect(roundTripped.id, original.id);
      expect(roundTripped.title, original.title);
      expect(roundTripped.content, original.content);
      expect(roundTripped.disciplineId, original.disciplineId);
      expect(roundTripped.createdAt, original.createdAt);
      expect(roundTripped.updatedAt, original.updatedAt);
    });
  });
}
