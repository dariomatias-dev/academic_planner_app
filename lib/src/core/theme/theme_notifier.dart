import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:academic_planner/src/core/services/shared_preferences_service.dart';
import 'package:academic_planner/src/core/shared_preferences_keys.dart';

class ThemeNotifier extends ChangeNotifier {
  final SharedPreferencesService _preferences;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeNotifier(this._preferences) {
    _loadTheme();

    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
          if (_themeMode == ThemeMode.system) {
            notifyListeners();
          }
        };
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }

    return _themeMode == ThemeMode.dark;
  }

  Future<void> _loadTheme() async {
    final value = _preferences.getString(SharedPreferencesKeys.themeModeKey);

    if (value == 'light') {
      _themeMode = ThemeMode.light;
    } else if (value == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    await _saveTheme();

    notifyListeners();
  }

  Future<void> _saveTheme() async {
    String value;

    switch (_themeMode) {
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.system:
        value = 'system';
        break;
    }

    await _preferences.setString(SharedPreferencesKeys.themeModeKey, value);
  }
}
