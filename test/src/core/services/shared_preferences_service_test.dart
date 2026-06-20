import 'package:academic_planner/src/core/services/shared_preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferencesService sut;

  Future<void> init([Map<String, Object> values = const {}]) async {
    SharedPreferences.setMockInitialValues(values);
    final prefs = await SharedPreferences.getInstance();
    sut = SharedPreferencesService(prefs);
  }

  group('String', () {
    test('getString returns stored value', () async {
      await init({'key': 'value'});

      expect(sut.getString('key'), 'value');
    });

    test('getString returns defaultValue when missing', () async {
      await init();

      expect(sut.getString('missing', defaultValue: 'fallback'), 'fallback');
    });

    test('getString returns empty string by default when missing', () async {
      await init();

      expect(sut.getString('missing'), '');
    });

    test('getStringOrNull returns null when missing', () async {
      await init();

      expect(sut.getStringOrNull('missing'), isNull);
    });

    test('setString persists the value', () async {
      await init();

      final ok = await sut.setString('key', 'value');

      expect(ok, isTrue);
      expect(sut.getString('key'), 'value');
    });
  });

  group('Bool', () {
    test('getBool returns stored value', () async {
      await init({'key': true});

      expect(sut.getBool('key'), isTrue);
    });

    test('getBool returns defaultValue when missing', () async {
      await init();

      expect(sut.getBool('missing', defaultValue: true), isTrue);
    });

    test('getBoolOrNull returns null when missing', () async {
      await init();

      expect(sut.getBoolOrNull('missing'), isNull);
    });

    test('setBool persists the value', () async {
      await init();

      final ok = await sut.setBool('key', value: true);

      expect(ok, isTrue);
      expect(sut.getBool('key'), isTrue);
    });
  });

  group('Int', () {
    test('getInt returns stored value', () async {
      await init({'key': 42});

      expect(sut.getInt('key'), 42);
    });

    test('getInt returns defaultValue when missing', () async {
      await init();

      expect(sut.getInt('missing', defaultValue: 7), 7);
    });

    test('getIntOrNull returns null when missing', () async {
      await init();

      expect(sut.getIntOrNull('missing'), isNull);
    });

    test('setInt persists the value', () async {
      await init();

      final ok = await sut.setInt('key', 42);

      expect(ok, isTrue);
      expect(sut.getInt('key'), 42);
    });
  });

  group('Double', () {
    test('getDouble returns stored value', () async {
      await init({'key': 4.2});

      expect(sut.getDouble('key'), 4.2);
    });

    test('getDouble returns defaultValue when missing', () async {
      await init();

      expect(sut.getDouble('missing', defaultValue: 1.5), 1.5);
    });

    test('getDoubleOrNull returns null when missing', () async {
      await init();

      expect(sut.getDoubleOrNull('missing'), isNull);
    });

    test('setDouble persists the value', () async {
      await init();

      final ok = await sut.setDouble('key', 4.2);

      expect(ok, isTrue);
      expect(sut.getDouble('key'), 4.2);
    });
  });

  group('StringList', () {
    test('getStringList returns stored value', () async {
      await init({
        'key': ['a', 'b'],
      });

      expect(sut.getStringList('key'), ['a', 'b']);
    });

    test('getStringList returns defaultValue when missing', () async {
      await init();

      expect(sut.getStringList('missing', defaultValue: ['x']), ['x']);
    });

    test('getStringList returns empty list by default when missing', () async {
      await init();

      expect(sut.getStringList('missing'), isEmpty);
    });

    test('getStringListOrNull returns null when missing', () async {
      await init();

      expect(sut.getStringListOrNull('missing'), isNull);
    });

    test('setStringList persists the value', () async {
      await init();

      final ok = await sut.setStringList('key', ['a', 'b']);

      expect(ok, isTrue);
      expect(sut.getStringList('key'), ['a', 'b']);
    });
  });

  group('remove', () {
    test('removes the stored value for the key', () async {
      await init({'key': 'value'});

      final ok = await sut.remove('key');

      expect(ok, isTrue);
      expect(sut.getStringOrNull('key'), isNull);
    });
  });

  group('clear', () {
    test('removes all stored values', () async {
      await init({'a': '1', 'b': '2'});

      final ok = await sut.clear();

      expect(ok, isTrue);
      expect(sut.getStringOrNull('a'), isNull);
      expect(sut.getStringOrNull('b'), isNull);
    });
  });
}
