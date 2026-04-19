import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';
import 'package:academic_planner/src/core/services/shared_preferences_service.dart';
import 'package:academic_planner/src/core/shared_preferences_keys.dart';

class UserDisciplinesNotifier extends Notifier<Set<int>> {
  late final SharedPreferencesService _prefs;

  @override
  Set<int> build() {
    _prefs = ref.read(sharedPreferencesServiceProvider);

    final storedIds = _prefs.getStringListOrNull(
      SharedPreferencesKeys.userDisciplinesKey,
    );

    if (storedIds != null) {
      return storedIds.map(int.parse).toSet();
    }

    return {};
  }

  Future<void> toggleDiscipline(int id) async {
    final newSet = Set<int>.from(state);

    if (newSet.contains(id)) {
      newSet.remove(id);
    } else {
      newSet.add(id);
    }

    state = newSet;

    await _prefs.setStringList(
      SharedPreferencesKeys.userDisciplinesKey,
      newSet.map((id) => id.toString()).toList(),
    );
  }
}
