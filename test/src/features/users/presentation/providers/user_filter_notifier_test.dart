import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/value_objects/user_filter.dart';
import 'package:academic_planner/src/features/users/presentation/providers/user_filter_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;
  late NotifierProvider<UserFilterNotifier, UserFilter> provider;

  setUp(() {
    provider = NotifierProvider<UserFilterNotifier, UserFilter>(
      UserFilterNotifier.new,
    );
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  test('build → returns default UserFilter', () {
    final filter = container.read(provider);

    expect(filter.query, '');
    expect(filter.role, isNull);
  });

  group('setQuery', () {
    test('updates the query and preserves the role', () {
      container.read(provider.notifier)
        ..setRole(UserRole.teacher)
        ..setQuery('ana');

      final filter = container.read(provider);
      expect(filter.query, 'ana');
      expect(filter.role, UserRole.teacher);
    });
  });

  group('setRole', () {
    test('non-null role → sets the role', () {
      container.read(provider.notifier).setRole(UserRole.admin);

      expect(container.read(provider).role, UserRole.admin);
    });

    test('null role → clears the role', () {
      container.read(provider.notifier)
        ..setRole(UserRole.admin)
        ..setRole(null);

      expect(container.read(provider).role, isNull);
    });
  });
}
