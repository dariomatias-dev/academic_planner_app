import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/services/shared_preferences_service.dart';
import 'package:academic_planner/src/core/shared_preferences_keys.dart';

class UserDisciplinesNotifier extends ChangeNotifier {
  final SharedPreferencesService _prefs;

  Set<int> _selectedIds = {};
  Set<int> get selectedIds => _selectedIds;

  UserDisciplinesNotifier(this._prefs) {
    _loadSelectedIds();
  }

  void _loadSelectedIds() {
    final storedIds = _prefs.getStringListOrNull(
      SharedPreferencesKeys.userDisciplinesKey,
    );

    if (storedIds != null) {
      _selectedIds = storedIds.map(int.parse).toSet();
      notifyListeners();
    }
  }

  Future<void> toggleDiscipline(int id) async {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }

    notifyListeners();

    await _prefs.setStringList(
      SharedPreferencesKeys.userDisciplinesKey,
      _selectedIds.map((id) => id.toString()).toList(),
    );
  }
}
