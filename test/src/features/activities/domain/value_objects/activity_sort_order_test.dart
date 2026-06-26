import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivitySortOrder.label', () {
    test('asc → "Crescente"', () {
      expect(ActivitySortOrder.asc.label, 'Crescente');
    });

    test('desc → "Decrescente"', () {
      expect(ActivitySortOrder.desc.label, 'Decrescente');
    });
  });
}
