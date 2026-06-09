import 'dart:convert';

import 'package:academic_planner/src/core/services/shared_preferences_service.dart';
import 'package:academic_planner/src/features/categories/data/data_source/category_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<CategoryLocalDataSource> _makeSut({
  Map<String, Object> initialValues = const {},
}) async {
  SharedPreferences.setMockInitialValues(initialValues);
  final prefs = await SharedPreferences.getInstance();
  return CategoryLocalDataSource(SharedPreferencesService(prefs));
}

void main() {
  group('CategoryLocalDataSource.getAll', () {
    test('no key stored → empty list', () async {
      final sut = await _makeSut();
      expect(sut.getAll(), isEmpty);
    });

    test('empty JSON array stored → empty list', () async {
      final sut = await _makeSut(
        initialValues: {'categories': jsonEncode(<dynamic>[])},
      );
      expect(sut.getAll(), isEmpty);
    });

    test('valid JSON → returns correct list', () async {
      final data = [
        {'name': 'Exam'},
        {'name': 'Assignment'},
      ];
      final sut = await _makeSut(
        initialValues: {'categories': jsonEncode(data)},
      );
      final result = sut.getAll();
      expect(result.length, 2);
      expect(result[0]['name'], 'Exam');
      expect(result[1]['name'], 'Assignment');
    });

    test('single item → list with one element', () async {
      final sut = await _makeSut(
        initialValues: {
          'categories': jsonEncode([
            {'name': 'Study'},
          ]),
        },
      );
      final result = sut.getAll();
      expect(result.length, 1);
      expect(result.first['name'], 'Study');
    });
  });

  group('CategoryLocalDataSource.saveAll', () {
    test('saveAll → getAll returns saved data', () async {
      final sut = await _makeSut();
      await sut.saveAll([
        {'name': 'Study'},
        {'name': 'Reading'},
      ]);
      final result = sut.getAll();
      expect(result.length, 2);
      expect(result[0]['name'], 'Study');
      expect(result[1]['name'], 'Reading');
    });

    test('saveAll empty list → getAll returns empty', () async {
      final sut = await _makeSut();
      await sut.saveAll([]);
      expect(sut.getAll(), isEmpty);
    });

    test('saveAll overwrites previous data', () async {
      final sut = await _makeSut(
        initialValues: {
          'categories': jsonEncode([
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
