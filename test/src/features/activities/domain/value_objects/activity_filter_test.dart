import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_field.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityFilter.copyWith', () {
    final base = ActivityFilter(
      search: 'math',
      disciplineId: 1,
      startDate: DateTime(2025),
      endDate: DateTime(2025, 12, 31),
      dueBefore: DateTime(2025, 6),
      dueAfter: DateTime(2025, 3),
      statuses: [ActivityStatus.pending],
      category: 'homework',
      tags: ['tag1'],
      sortField: ActivitySortField.title,
      sortOrder: ActivitySortOrder.asc,
    );

    test('no arguments → all fields preserved', () {
      final copy = base.copyWith();
      expect(copy.search, base.search);
      expect(copy.disciplineId, base.disciplineId);
      expect(copy.startDate, base.startDate);
      expect(copy.endDate, base.endDate);
      expect(copy.dueBefore, base.dueBefore);
      expect(copy.dueAfter, base.dueAfter);
      expect(copy.statuses, base.statuses);
      expect(copy.category, base.category);
      expect(copy.tags, base.tags);
      expect(copy.sortField, base.sortField);
      expect(copy.sortOrder, base.sortOrder);
    });

    test('overwritten field reflects new value', () {
      final copy = base.copyWith(search: 'physics');
      expect(copy.search, 'physics');
    });

    test('unrelated fields preserved when one field overwritten', () {
      final copy = base.copyWith(search: 'physics');
      expect(copy.disciplineId, base.disciplineId);
      expect(copy.sortField, base.sortField);
      expect(copy.sortOrder, base.sortOrder);
    });

    test('multiple fields overwritten independently', () {
      final copy = base.copyWith(
        disciplineId: 99,
        sortOrder: ActivitySortOrder.desc,
      );
      expect(copy.disciplineId, 99);
      expect(copy.sortOrder, ActivitySortOrder.desc);
      expect(copy.search, base.search);
      expect(copy.sortField, base.sortField);
    });

    test('statuses overwritten', () {
      final copy = base.copyWith(
        statuses: [ActivityStatus.completed, ActivityStatus.canceled],
      );
      expect(copy.statuses, [
        ActivityStatus.completed,
        ActivityStatus.canceled,
      ]);
    });

    test('tags overwritten', () {
      final copy = base.copyWith(tags: ['a', 'b']);
      expect(copy.tags, ['a', 'b']);
    });

    test('copyWith on empty filter preserves nulls', () {
      const empty = ActivityFilter();
      final copy = empty.copyWith();
      expect(copy.search, isNull);
      expect(copy.disciplineId, isNull);
      expect(copy.statuses, isNull);
      expect(copy.sortField, isNull);
      expect(copy.sortOrder, isNull);
    });
  });
}
