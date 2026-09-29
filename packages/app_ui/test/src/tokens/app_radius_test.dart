import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppRadius values increase from xxs to huge', () {
    const scale = [
      AppRadius.xxs,
      AppRadius.xs,
      AppRadius.sm,
      AppRadius.md,
      AppRadius.lg,
      AppRadius.xl,
      AppRadius.xxl,
      AppRadius.xxxl,
      AppRadius.huge,
    ];

    expect(scale, orderedEquals([...scale]..sort()));
    expect(scale.toSet(), hasLength(scale.length));
  });

  test('AppRadius.pill is larger than every other radius', () {
    expect(AppRadius.pill, greaterThan(AppRadius.huge));
  });
}
