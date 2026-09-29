import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [widget] inside a `MaterialApp` on a fixed-size surface with a
/// fixed pixel ratio, so goldens render the same regardless of the host
/// screen. The surface is reset when the test ends.
Future<void> pumpGolden(
  WidgetTester tester,
  Widget widget, {
  Size size = const Size(400, 800),
  double devicePixelRatio = 1,
  ThemeData? theme,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = devicePixelRatio;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(body: Center(child: widget)),
    ),
  );
}
