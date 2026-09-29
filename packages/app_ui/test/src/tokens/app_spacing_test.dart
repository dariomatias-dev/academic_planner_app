import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppSpacing values increase from none to huge', () {
    const scale = [
      AppSpacing.none,
      AppSpacing.xxs,
      AppSpacing.xs,
      AppSpacing.sm,
      AppSpacing.md,
      AppSpacing.lg,
      AppSpacing.xl,
      AppSpacing.xxl,
      AppSpacing.xxxl,
      AppSpacing.huge,
    ];

    expect(scale.first, 0);
    expect(scale, orderedEquals([...scale]..sort()));
    expect(scale.toSet(), hasLength(scale.length));
  });

  test('AppSpacing keeps the values the app already uses', () {
    expect(AppSpacing.sm, 8);
    expect(AppSpacing.lg, 16);
    expect(AppSpacing.xxxl, 32);
  });
}
