import 'dart:convert';

import 'package:academic_planner/src/features/activities/data/models/activity_model.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _baseMap({
  String? tags,
  String? reminders,
  String? dueDate,
  String status = 'pending',
}) => {
  'id': 'abc-123',
  'title': 'Entrega do projeto',
  'description': 'Descrição',
  'notes': 'Anotações',
  'disciplineId': 42,
  'dueDate': dueDate,
  'category': 'Prova',
  'tags': tags,
  'reminders': reminders,
  'status': status,
  'createdAt': '2024-03-01T08:00:00.000',
  'updatedAt': '2024-03-02T10:00:00.000',
};

void main() {
  group('ActivityModel.fromMap — tags', () {
    test('tags null → lista vazia', () {
      final model = ActivityModel.fromMap(_baseMap());
      expect(model.tags, isEmpty);
    });

    test('tags string vazia → lista vazia', () {
      final model = ActivityModel.fromMap(_baseMap(tags: ''));
      expect(model.tags, isEmpty);
    });

    test('tags JSON válido → lista correta', () {
      final model = ActivityModel.fromMap(
        _baseMap(tags: jsonEncode(['flutter', 'dart'])),
      );
      expect(model.tags, ['flutter', 'dart']);
    });

    test('tags JSON array vazio → lista vazia', () {
      final model = ActivityModel.fromMap(_baseMap(tags: jsonEncode([])));
      expect(model.tags, isEmpty);
    });

    test('tags com elemento único → lista com um item', () {
      final model = ActivityModel.fromMap(
        _baseMap(tags: jsonEncode(['único'])),
      );
      expect(model.tags, ['único']);
    });
  });

  group('ActivityModel.fromMap — reminders', () {
    test('reminders null → lista vazia', () {
      final model = ActivityModel.fromMap(_baseMap());
      expect(model.reminders, isEmpty);
    });

    test('reminders string vazia → lista vazia', () {
      final model = ActivityModel.fromMap(_baseMap(reminders: ''));
      expect(model.reminders, isEmpty);
    });

    test('reminders JSON válido → lista de TimeOfDay', () {
      final encoded = jsonEncode([
        {'hour': 9, 'minute': 30},
        {'hour': 14, 'minute': 0},
      ]);
      final model = ActivityModel.fromMap(_baseMap(reminders: encoded));

      expect(model.reminders.length, 2);
      expect(model.reminders[0], const TimeOfDay(hour: 9, minute: 30));
      expect(model.reminders[1], const TimeOfDay(hour: 14, minute: 0));
    });

    test('reminders JSON array vazio → lista vazia', () {
      final model = ActivityModel.fromMap(
        _baseMap(reminders: jsonEncode([])),
      );
      expect(model.reminders, isEmpty);
    });

    test('reminder midnight preservado (00:00)', () {
      final encoded = jsonEncode([
        {'hour': 0, 'minute': 0},
      ]);
      final model = ActivityModel.fromMap(_baseMap(reminders: encoded));
      expect(model.reminders.first, const TimeOfDay(hour: 0, minute: 0));
    });
  });

  group('ActivityModel.fromMap — status', () {
    for (final status in ActivityStatus.values) {
      test('status "${status.name}" → $status', () {
        final model = ActivityModel.fromMap(_baseMap(status: status.name));
        expect(model.status, status);
      });
    }

    test('status desconhecido → draft', () {
      final model = ActivityModel.fromMap(_baseMap(status: 'inexistente'));
      expect(model.status, ActivityStatus.draft);
    });

    test('status vazio → draft', () {
      final model = ActivityModel.fromMap(_baseMap(status: ''));
      expect(model.status, ActivityStatus.draft);
    });
  });

  group('ActivityModel.fromMap — dueDate', () {
    test('dueDate null → null preservado', () {
      final model = ActivityModel.fromMap(_baseMap());
      expect(model.dueDate, isNull);
    });

    test('dueDate ISO 8601 → DateTime correto', () {
      final model = ActivityModel.fromMap(
        _baseMap(dueDate: '2024-06-15T23:59:00.000'),
      );
      expect(model.dueDate, DateTime.parse('2024-06-15T23:59:00.000'));
    });
  });

  group('ActivityModel.toMap', () {
    test('tags lista → JSON string no map', () {
      final model = ActivityModel.fromMap(
        _baseMap(tags: jsonEncode(['a', 'b'])),
      );
      final map = model.toMap();
      expect(map['tags'], jsonEncode(['a', 'b']));
    });

    test('tags vazia → JSON "[]" no map', () {
      final model = ActivityModel.fromMap(_baseMap());
      final map = model.toMap();
      expect(map['tags'], jsonEncode([]));
    });

    test('reminders lista → JSON string no map', () {
      final encoded = jsonEncode([
        {'hour': 7, 'minute': 15},
      ]);
      final model = ActivityModel.fromMap(_baseMap(reminders: encoded));
      final map = model.toMap();
      expect(map['reminders'], encoded);
    });

    test('reminders vazia → JSON "[]" no map', () {
      final model = ActivityModel.fromMap(_baseMap());
      final map = model.toMap();
      expect(map['reminders'], jsonEncode([]));
    });

    test('dueDate null → null no map', () {
      final model = ActivityModel.fromMap(_baseMap());
      expect(model.toMap()['dueDate'], isNull);
    });

    test('dueDate presente → ISO 8601 string no map', () {
      const iso = '2024-06-15T23:59:00.000';
      final model = ActivityModel.fromMap(_baseMap(dueDate: iso));
      expect(model.toMap()['dueDate'], iso);
    });

    test('status → name string no map', () {
      final model = ActivityModel.fromMap(_baseMap(status: 'inProgress'));
      expect(model.toMap()['status'], 'inProgress');
    });
  });

  group('ActivityModel fromMap → toMap round-trip', () {
    test('completo com tags, reminders e dueDate', () {
      final tags = jsonEncode(['dart', 'flutter']);
      final reminders = jsonEncode([
        {'hour': 8, 'minute': 0},
        {'hour': 20, 'minute': 30},
      ]);
      const dueDate = '2024-09-01T12:00:00.000';

      final original = _baseMap(
        tags: tags,
        reminders: reminders,
        dueDate: dueDate,
        status: 'completed',
      );

      final roundTripped = ActivityModel.fromMap(original).toMap();

      expect(roundTripped['id'], original['id']);
      expect(roundTripped['title'], original['title']);
      expect(roundTripped['description'], original['description']);
      expect(roundTripped['notes'], original['notes']);
      expect(roundTripped['disciplineId'], original['disciplineId']);
      expect(roundTripped['dueDate'], dueDate);
      expect(roundTripped['category'], original['category']);
      expect(roundTripped['tags'], tags);
      expect(roundTripped['reminders'], reminders);
      expect(roundTripped['status'], 'completed');
      expect(roundTripped['createdAt'], original['createdAt']);
      expect(roundTripped['updatedAt'], original['updatedAt']);
    });

    test('minimal: tags null, reminders null, dueDate null', () {
      final original = _baseMap(status: 'draft');

      final roundTripped = ActivityModel.fromMap(original).toMap();

      expect(roundTripped['tags'], jsonEncode([]));
      expect(roundTripped['reminders'], jsonEncode([]));
      expect(roundTripped['dueDate'], isNull);
      expect(roundTripped['status'], 'draft');
    });
  });
}
