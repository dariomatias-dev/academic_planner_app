import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppPalette keeps the brand and neutral values', () {
    expect(AppPalette.emerald700, const Color(0xFF047857));
    expect(AppPalette.slate100, const Color(0xFFF1F5F9));
    expect(AppPalette.zinc950, const Color(0xFF09090B));
    expect(AppPalette.white, const Color(0xFFFFFFFF));
    expect(AppPalette.transparent.a, 0);
  });
}
