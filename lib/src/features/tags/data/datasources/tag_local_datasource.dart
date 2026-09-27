import 'dart:convert';

import 'package:academic_planner/src/core/services/shared_preferences_service.dart';

class TagLocalDataSource {
  TagLocalDataSource(this.prefs);

  final SharedPreferencesService prefs;

  static const _key = 'tags';

  List<Map<String, dynamic>> getAll() {
    final jsonString = prefs.getString(_key);

    if (jsonString.isEmpty) return [];

    final decoded = jsonDecode(jsonString) as List<dynamic>;

    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> saveAll(List<Map<String, dynamic>> data) async {
    await prefs.setString(_key, jsonEncode(data));
  }
}
