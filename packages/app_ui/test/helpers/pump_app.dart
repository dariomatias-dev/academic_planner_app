import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [child] inside a minimal `MaterialApp` + `Scaffold` using the
/// design system theme ([AppTheme.light] unless [theme] is given).
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  ThemeData? theme,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: theme ?? AppTheme.light(),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

/// Pumps a `MaterialApp` with a single button whose [onPressed] receives a
/// [BuildContext] scoped under a real `Navigator` — the context overlay
/// APIs (`showDialog`) require to work in tests.
///
/// Tap the button (`find.text(triggerLabel)`) to invoke [onPressed], then
/// `pumpAndSettle` to let the overlay animate in.
Future<void> pumpScopedApp(
  WidgetTester tester,
  void Function(BuildContext context) onPressed, {
  String triggerLabel = 'trigger',
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => onPressed(context),
              child: Text(triggerLabel),
            );
          },
        ),
      ),
    ),
  );
}
