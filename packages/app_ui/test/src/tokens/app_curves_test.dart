import 'package:app_ui/app_ui.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppCurves map to the expected Flutter curves', () {
    expect(AppCurves.standard, Curves.easeInOut);
    expect(AppCurves.enter, Curves.easeOut);
    expect(AppCurves.exit, Curves.easeIn);
    expect(AppCurves.emphasized, Curves.easeOutQuart);
    expect(AppCurves.bounce, Curves.elasticOut);
  });

  test('every AppCurves curve starts at 0 and ends at 1', () {
    for (final curve in [
      AppCurves.standard,
      AppCurves.enter,
      AppCurves.exit,
      AppCurves.emphasized,
      AppCurves.bounce,
    ]) {
      expect(curve.transform(0), 0);
      expect(curve.transform(1), closeTo(1, 1e-9));
    }
  });
}
