import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';
import 'package:academic_planner/src/core/services/shared_preferences_service.dart';
import 'package:academic_planner/src/core/shared_preferences_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  late final SharedPreferencesService _preferences;

  @override
  ThemeMode build() {
    _preferences = ref.read(sharedPreferencesServiceProvider);

    final value = _preferences.getString(SharedPreferencesKeys.themeModeKey);

    if (value == 'light') {
      return ThemeMode.light;
    } else if (value == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  bool get isDarkMode {
    if (state == ThemeMode.system) {
      return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }

    return state == ThemeMode.dark;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;

    String value;

    switch (mode) {
      case ThemeMode.light:
        value = 'light';
      case ThemeMode.dark:
        value = 'dark';
      case ThemeMode.system:
        value = 'system';
    }

    await _preferences.setString(SharedPreferencesKeys.themeModeKey, value);
  }
}
