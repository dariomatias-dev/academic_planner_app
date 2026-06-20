import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';
import 'package:academic_planner/src/core/services/shared_preferences_service.dart';
import 'package:academic_planner/src/core/shared_preferences_keys.dart';
import 'package:academic_planner/src/features/disciplines/presentation/providers/user_disciplines_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferencesService extends Mock
    implements SharedPreferencesService {}

void main() {
  late MockSharedPreferencesService mockPrefs;
  late ProviderContainer container;
  late NotifierProvider<UserDisciplinesNotifier, Set<int>> provider;

  setUp(() {
    mockPrefs = MockSharedPreferencesService();
    provider = NotifierProvider<UserDisciplinesNotifier, Set<int>>(
      UserDisciplinesNotifier.new,
    );
    container = ProviderContainer(
      overrides: [
        sharedPreferencesServiceProvider.overrideWithValue(mockPrefs),
      ],
    );
    addTearDown(container.dispose);
  });

  group('build', () {
    test('no stored ids → returns empty set', () {
      when(
        () => mockPrefs.getStringListOrNull(
          SharedPreferencesKeys.userDisciplinesKey,
        ),
      ).thenReturn(null);

      final state = container.read(provider);

      expect(state, isEmpty);
    });

    test('stored ids → parses them into a set of ints', () {
      when(
        () => mockPrefs.getStringListOrNull(
          SharedPreferencesKeys.userDisciplinesKey,
        ),
      ).thenReturn(['1', '2', '3']);

      final state = container.read(provider);

      expect(state, {1, 2, 3});
    });
  });

  group('toggleDiscipline', () {
    setUp(() {
      when(
        () => mockPrefs.getStringListOrNull(
          SharedPreferencesKeys.userDisciplinesKey,
        ),
      ).thenReturn(['1']);
      when(
        () => mockPrefs.setStringList(any(), any()),
      ).thenAnswer((_) async => true);
    });

    test('id not present → adds it and persists', () async {
      await container.read(provider.notifier).toggleDiscipline(2);

      expect(container.read(provider), {1, 2});
      verify(
        () => mockPrefs.setStringList(
          SharedPreferencesKeys.userDisciplinesKey,
          any(that: unorderedEquals(['1', '2'])),
        ),
      ).called(1);
    });

    test('id already present → removes it and persists', () async {
      await container.read(provider.notifier).toggleDiscipline(1);

      expect(container.read(provider), isEmpty);
      verify(
        () => mockPrefs.setStringList(
          SharedPreferencesKeys.userDisciplinesKey,
          <String>[],
        ),
      ).called(1);
    });
  });
}
