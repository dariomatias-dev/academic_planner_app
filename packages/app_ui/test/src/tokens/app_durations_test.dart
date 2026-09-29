import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppDurations increase from fast to ambient', () {
    const durations = [
      AppDurations.fast,
      AppDurations.normal,
      AppDurations.slow,
      AppDurations.slower,
      AppDurations.ambient,
    ];

    expect(durations, orderedEquals([...durations]..sort()));
    expect(durations.toSet(), hasLength(durations.length));
  });
}
