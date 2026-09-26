import 'package:shared_preferences/shared_preferences.dart';

/// Returns a real [SharedPreferences] instance backed by in-memory mock
/// values, for tests that read from or write to preferences directly.
Future<SharedPreferences> fakeSharedPreferences([
  Map<String, Object> values = const {},
]) async {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}
