import 'package:flutter/material.dart';

extension ThemeModeExtension on ThemeMode {
  String get label {
    switch (this) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Escuro';
      case ThemeMode.system:
        return 'Sistema';
    }
  }
}
