import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_filter_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;
  late NotifierProvider<ActivityFilterNotifier, ActivityFilter> provider;

  setUp(() {
    container = ProviderContainer();
    provider = NotifierProvider<ActivityFilterNotifier, ActivityFilter>(
      ActivityFilterNotifier.new,
    );
    addTearDown(container.dispose);
  });

  test('build → returns default ActivityFilter', () {
    final filter = container.read(provider);

    expect(filter.search, isNull);
    expect(filter.disciplineId, isNull);
    expect(filter.startDate, isNull);
    expect(filter.endDate, isNull);
    expect(filter.statuses, isNull);
  });

  group('filter setter', () {
    test('replaces entire state', () {
      final notifier = container.read(provider.notifier);
      const newFilter = ActivityFilter(search: 'math');

      notifier.filter = newFilter;

      expect(container.read(provider), same(newFilter));
      expect(notifier.filter, same(newFilter));
    });
  });

  group('update', () {
    test('no arguments → fields unchanged', () {
      final notifier = container.read(provider.notifier);
      final before = container.read(provider);

      notifier.update();

      final after = container.read(provider);
      expect(after.search, before.search);
      expect(after.disciplineId, before.disciplineId);
      expect(after.startDate, before.startDate);
      expect(after.endDate, before.endDate);
      expect(after.statuses, before.statuses);
    });

    test('sets provided fields and preserves the rest', () {
      container.read(provider.notifier)
        ..update(search: 'math', disciplineId: 1)
        ..update(statuses: [ActivityStatus.pending]);

      final filter = container.read(provider);
      expect(filter.search, 'math');
      expect(filter.disciplineId, 1);
      expect(filter.statuses, [ActivityStatus.pending]);
    });

    test('startDate and endDate are set independently', () {
      final notifier = container.read(provider.notifier);
      final start = DateTime(2025);
      final end = DateTime(2025, 12, 31);

      notifier.update(startDate: start, endDate: end);

      final filter = container.read(provider);
      expect(filter.startDate, start);
      expect(filter.endDate, end);
    });
  });
}
