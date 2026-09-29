import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppSizes icon sizes increase from xs to huge', () {
    const icons = [
      AppSizes.iconXs,
      AppSizes.iconSm,
      AppSizes.iconMd,
      AppSizes.iconLg,
      AppSizes.iconXl,
      AppSizes.iconHuge,
    ];

    expect(icons, orderedEquals([...icons]..sort()));
    expect(icons.toSet(), hasLength(icons.length));
  });

  test('AppSizes controls are at least the minimum tap target', () {
    expect(AppSizes.controlSm, lessThan(AppSizes.controlMd));
    expect(AppSizes.controlMd, lessThan(AppSizes.controlLg));
    expect(AppSizes.controlMd, greaterThanOrEqualTo(AppSizes.minTapTarget));
  });
}
