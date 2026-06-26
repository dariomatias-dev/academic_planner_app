import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_field.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivitySortField.label', () {
    test('title → "Título"', () {
      expect(ActivitySortField.title.label, 'Título');
    });

    test('dueDate → "Data de Entrega"', () {
      expect(ActivitySortField.dueDate.label, 'Data de Entrega');
    });

    test('createdAt → "Data de Criação"', () {
      expect(ActivitySortField.createdAt.label, 'Data de Criação');
    });

    test('updatedAt → "Última Atualização"', () {
      expect(ActivitySortField.updatedAt.label, 'Última Atualização');
    });
  });

  group('ActivitySortField.column', () {
    test('title → "title"', () {
      expect(ActivitySortField.title.column, 'title');
    });

    test('dueDate → "dueDate"', () {
      expect(ActivitySortField.dueDate.column, 'dueDate');
    });

    test('createdAt → "createdAt"', () {
      expect(ActivitySortField.createdAt.column, 'createdAt');
    });

    test('updatedAt → "updatedAt"', () {
      expect(ActivitySortField.updatedAt.column, 'updatedAt');
    });
  });

  group('ActivitySortField.defaultOrder', () {
    test('title → asc', () {
      expect(ActivitySortField.title.defaultOrder, ActivitySortOrder.asc);
    });

    test('dueDate → asc', () {
      expect(ActivitySortField.dueDate.defaultOrder, ActivitySortOrder.asc);
    });

    test('createdAt → desc', () {
      expect(ActivitySortField.createdAt.defaultOrder, ActivitySortOrder.desc);
    });

    test('updatedAt → desc', () {
      expect(ActivitySortField.updatedAt.defaultOrder, ActivitySortOrder.desc);
    });
  });
}
