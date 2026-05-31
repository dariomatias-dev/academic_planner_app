import 'dart:convert';

import 'package:academic_planner/src/core/services/shared_preferences_service.dart';

class TagLocalDataSource {
  final SharedPreferencesService prefs;

  static const _key = 'tags';

  TagLocalDataSource(this.prefs);

  List<Map<String, dynamic>> getAll() {
    final jsonString = prefs.getString(_key);

    if (jsonString.isEmpty) return [];

    final List decoded = jsonDecode(jsonString);

    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> saveAll(List<Map<String, dynamic>> data) async {
    await prefs.setString(_key, jsonEncode(data));
  }
}
