import 'package:academic_planner/src/core/services/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return SharedPreferencesService(prefs);
});
