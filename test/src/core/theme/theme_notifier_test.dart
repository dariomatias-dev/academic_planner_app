import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';
import 'package:academic_planner/src/core/services/shared_preferences_service.dart';
import 'package:academic_planner/src/core/shared_preferences_keys.dart';
import 'package:academic_planner/src/core/theme/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferencesService extends Mock
    implements SharedPreferencesService {}

void main() {
  late MockSharedPreferencesService mockPrefs;
  late ProviderContainer container;
  late NotifierProvider<ThemeNotifier, ThemeMode> provider;

  setUp(() {
    mockPrefs = MockSharedPreferencesService();
    provider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);
    container = ProviderContainer(
      overrides: [
        sharedPreferencesServiceProvider.overrideWithValue(mockPrefs),
      ],
    );
    addTearDown(container.dispose);

    when(
      () => mockPrefs.setString(any(), any()),
    ).thenAnswer((_) async => true);
  });

  group('build', () {
    test('stored "light" → ThemeMode.light', () {
      when(
        () => mockPrefs.getString(SharedPreferencesKeys.themeModeKey),
      ).thenReturn('light');

      expect(container.read(provider), ThemeMode.light);
    });

    test('stored "dark" → ThemeMode.dark', () {
      when(
        () => mockPrefs.getString(SharedPreferencesKeys.themeModeKey),
      ).thenReturn('dark');

      expect(container.read(provider), ThemeMode.dark);
    });

    test('nothing stored → ThemeMode.system', () {
      when(
        () => mockPrefs.getString(SharedPreferencesKeys.themeModeKey),
      ).thenReturn('');

      expect(container.read(provider), ThemeMode.system);
    });
  });

  group('isDarkMode', () {
    test('state dark → true', () {
      when(
        () => mockPrefs.getString(SharedPreferencesKeys.themeModeKey),
      ).thenReturn('dark');

      expect(container.read(provider.notifier).isDarkMode, isTrue);
    });

    test('state light → false', () {
      when(
        () => mockPrefs.getString(SharedPreferencesKeys.themeModeKey),
      ).thenReturn('light');

      expect(container.read(provider.notifier).isDarkMode, isFalse);
    });

    testWidgets('state system → follows the platform brightness', (
      tester,
    ) async {
      when(
        () => mockPrefs.getString(SharedPreferencesKeys.themeModeKey),
      ).thenReturn('');

      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      expect(container.read(provider.notifier).isDarkMode, isTrue);

      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      expect(container.read(provider.notifier).isDarkMode, isFalse);
    });
  });

  group('setThemeMode', () {
    setUp(() {
      when(
        () => mockPrefs.getString(SharedPreferencesKeys.themeModeKey),
      ).thenReturn('');
    });

    test('updates the state and persists the mode', () async {
      await container.read(provider.notifier).setThemeMode(ThemeMode.light);

      expect(container.read(provider), ThemeMode.light);
      verify(
        () => mockPrefs.setString(
          SharedPreferencesKeys.themeModeKey,
          'light',
        ),
      ).called(1);

      await container.read(provider.notifier).setThemeMode(ThemeMode.dark);

      expect(container.read(provider), ThemeMode.dark);
      verify(
        () => mockPrefs.setString(SharedPreferencesKeys.themeModeKey, 'dark'),
      ).called(1);

      await container.read(provider.notifier).setThemeMode(ThemeMode.system);

      expect(container.read(provider), ThemeMode.system);
      verify(
        () => mockPrefs.setString(
          SharedPreferencesKeys.themeModeKey,
          'system',
        ),
      ).called(1);
    });
  });
}
