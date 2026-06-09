import 'dart:convert';

import 'package:academic_planner/src/core/services/shared_preferences_service.dart';
import 'package:academic_planner/src/features/tags/data/data_source/tag_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<TagLocalDataSource> _makeSut({
  Map<String, Object> initialValues = const {},
}) async {
  SharedPreferences.setMockInitialValues(initialValues);
  final prefs = await SharedPreferences.getInstance();
  return TagLocalDataSource(SharedPreferencesService(prefs));
}

void main() {
  group('TagLocalDataSource.getAll', () {
    test('no key stored → empty list', () async {
      final sut = await _makeSut();
      expect(sut.getAll(), isEmpty);
    });

    test('empty JSON array stored → empty list', () async {
      final sut = await _makeSut(
        initialValues: {'tags': jsonEncode(<dynamic>[])},
      );
      expect(sut.getAll(), isEmpty);
    });

    test('valid JSON → returns correct list', () async {
      final data = [
        {'name': 'Urgent'},
        {'name': 'Practical'},
      ];
      final sut = await _makeSut(
        initialValues: {'tags': jsonEncode(data)},
      );
      final result = sut.getAll();
      expect(result.length, 2);
      expect(result[0]['name'], 'Urgent');
      expect(result[1]['name'], 'Practical');
    });

    test('single item → list with one element', () async {
      final sut = await _makeSut(
        initialValues: {
          'tags': jsonEncode([
            {'name': 'Group'},
          ]),
        },
      );
      final result = sut.getAll();
      expect(result.length, 1);
      expect(result.first['name'], 'Group');
    });
  });

  group('TagLocalDataSource.saveAll', () {
    test('saveAll → getAll returns saved data', () async {
      final sut = await _makeSut();
      await sut.saveAll([
        {'name': 'Urgent'},
        {'name': 'Theoretical'},
      ]);
      final result = sut.getAll();
      expect(result.length, 2);
      expect(result[0]['name'], 'Urgent');
      expect(result[1]['name'], 'Theoretical');
    });

    test('saveAll empty list → getAll returns empty', () async {
      final sut = await _makeSut();
      await sut.saveAll([]);
      expect(sut.getAll(), isEmpty);
    });

    test('saveAll overwrites previous data', () async {
      final sut = await _makeSut(
        initialValues: {
          'tags': jsonEncode([
            {'name': 'Old'},
          ]),
        },
      );
      await sut.saveAll([{'name': 'New'}]);
      final result = sut.getAll();
      expect(result.length, 1);
      expect(result.first['name'], 'New');
    });

    test('saveAll multiple items → all persisted in order', () async {
      final sut = await _makeSut();
      await sut.saveAll([
        {'name': 'A'},
        {'name': 'B'},
        {'name': 'C'},
      ]);
      final result = sut.getAll();
      expect(result.map((r) => r['name']).toList(), ['A', 'B', 'C']);
    });
  });
}
