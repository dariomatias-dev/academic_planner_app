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
  'title': 'Project submission',
  'description': 'Description',
  'notes': 'Notes',
  'disciplineId': 42,
  'dueDate': dueDate,
  'category': 'Exam',
  'tags': tags,
  'reminders': reminders,
  'status': status,
  'createdAt': '2024-03-01T08:00:00.000',
  'updatedAt': '2024-03-02T10:00:00.000',
};

void main() {
  group('ActivityModel.fromMap — tags', () {
    test('tags null → empty list', () {
      final model = ActivityModel.fromMap(_baseMap());
      expect(model.tags, isEmpty);
    });

    test('empty string tags → empty list', () {
      final model = ActivityModel.fromMap(_baseMap(tags: ''));
      expect(model.tags, isEmpty);
    });

    test('valid JSON tags → correct list', () {
      final model = ActivityModel.fromMap(
        _baseMap(tags: jsonEncode(['flutter', 'dart'])),
      );
      expect(model.tags, ['flutter', 'dart']);
    });

    test('empty JSON array tags → empty list', () {
      final model = ActivityModel.fromMap(_baseMap(tags: jsonEncode([])));
      expect(model.tags, isEmpty);
    });

    test('single-element tags → one-item list', () {
      final model = ActivityModel.fromMap(
        _baseMap(tags: jsonEncode(['single'])),
      );
      expect(model.tags, ['single']);
    });
  });

  group('ActivityModel.fromMap — reminders', () {
    test('reminders null → empty list', () {
      final model = ActivityModel.fromMap(_baseMap());
      expect(model.reminders, isEmpty);
    });

    test('empty string reminders → empty list', () {
      final model = ActivityModel.fromMap(_baseMap(reminders: ''));
      expect(model.reminders, isEmpty);
    });

    test('valid JSON reminders → TimeOfDay list', () {
      final encoded = jsonEncode([
        {'hour': 9, 'minute': 30},
        {'hour': 14, 'minute': 0},
      ]);
      final model = ActivityModel.fromMap(_baseMap(reminders: encoded));

      expect(model.reminders.length, 2);
      expect(model.reminders[0], const TimeOfDay(hour: 9, minute: 30));
      expect(model.reminders[1], const TimeOfDay(hour: 14, minute: 0));
    });

    test('empty JSON array reminders → empty list', () {
      final model = ActivityModel.fromMap(
        _baseMap(reminders: jsonEncode([])),
      );
      expect(model.reminders, isEmpty);
    });

    test('midnight reminder preserved (00:00)', () {
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

    test('unknown status → draft', () {
      final model = ActivityModel.fromMap(_baseMap(status: 'inexistente'));
      expect(model.status, ActivityStatus.draft);
    });

    test('empty status → draft', () {
      final model = ActivityModel.fromMap(_baseMap(status: ''));
      expect(model.status, ActivityStatus.draft);
    });
  });

  group('ActivityModel.fromMap — dueDate', () {
    test('dueDate null → null preserved', () {
      final model = ActivityModel.fromMap(_baseMap());
      expect(model.dueDate, isNull);
    });

    test('dueDate ISO 8601 → correct DateTime', () {
      final model = ActivityModel.fromMap(
        _baseMap(dueDate: '2024-06-15T23:59:00.000'),
      );
      expect(model.dueDate, DateTime.parse('2024-06-15T23:59:00.000'));
    });
  });

  group('ActivityModel.toMap', () {
    test('list tags → JSON string in map', () {
      final model = ActivityModel.fromMap(
        _baseMap(tags: jsonEncode(['a', 'b'])),
      );
      final map = model.toMap();
      expect(map['tags'], jsonEncode(['a', 'b']));
    });

    test('empty tags → JSON "[]" in map', () {
      final model = ActivityModel.fromMap(_baseMap());
      final map = model.toMap();
      expect(map['tags'], jsonEncode([]));
    });

    test('list reminders → JSON string in map', () {
      final encoded = jsonEncode([
        {'hour': 7, 'minute': 15},
      ]);
      final model = ActivityModel.fromMap(_baseMap(reminders: encoded));
      final map = model.toMap();
      expect(map['reminders'], encoded);
    });

    test('empty reminders → JSON "[]" in map', () {
      final model = ActivityModel.fromMap(_baseMap());
      final map = model.toMap();
      expect(map['reminders'], jsonEncode([]));
    });

    test('dueDate null → null in map', () {
      final model = ActivityModel.fromMap(_baseMap());
      expect(model.toMap()['dueDate'], isNull);
    });

    test('dueDate present → ISO 8601 string in map', () {
      const iso = '2024-06-15T23:59:00.000';
      final model = ActivityModel.fromMap(_baseMap(dueDate: iso));
      expect(model.toMap()['dueDate'], iso);
    });

    test('status → name string in map', () {
      final model = ActivityModel.fromMap(_baseMap(status: 'inProgress'));
      expect(model.toMap()['status'], 'inProgress');
    });
  });

  group('ActivityModel fromMap → toMap round-trip', () {
    test('complete with tags, reminders and dueDate', () {
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
