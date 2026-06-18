import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/value_objects/user_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserFilter.copyWith', () {
    final base = UserFilter(query: 'john', role: UserRole.teacher);

    test('no arguments → all fields preserved', () {
      final copy = base.copyWith();
      expect(copy.query, base.query);
      expect(copy.role, base.role);
    });

    test('overwritten field reflects new value', () {
      final copy = base.copyWith(query: 'mary');
      expect(copy.query, 'mary');
      expect(copy.role, base.role);
    });

    test('role overwritten with new value', () {
      final copy = base.copyWith(role: UserRole.admin);
      expect(copy.role, UserRole.admin);
      expect(copy.query, base.query);
    });

    test('clearRole removes role even if role argument passed', () {
      final copy = base.copyWith(role: UserRole.admin, clearRole: true);
      expect(copy.role, isNull);
    });

    test('clearRole defaults to false when omitted', () {
      final copy = base.copyWith();
      expect(copy.role, base.role);
    });

    test('copyWith on empty filter preserves defaults', () {
      final empty = UserFilter();
      final copy = empty.copyWith();
      expect(copy.query, '');
      expect(copy.role, isNull);
    });
  });
}
