import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [child] inside a minimal `MaterialApp` + `Scaffold`, the shape
/// most widget tests need. Pass [container] to scope it to a Riverpod
/// [ProviderContainer] with overridden providers, and set
/// [withQuillLocalizations] for widgets that render a Quill editor.
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  ProviderContainer? container,
  bool withQuillLocalizations = false,
}) async {
  Widget app = MaterialApp(
    localizationsDelegates: withQuillLocalizations
        ? const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ]
        : null,
    home: Scaffold(body: Center(child: child)),
  );

  if (container != null) {
    app = UncontrolledProviderScope(container: container, child: app);
  }

  await tester.pumpWidget(app);
}

/// Pumps a `MaterialApp` with a single button whose [onPressed] receives a
/// [BuildContext] scoped under a real `Navigator` — the context overlay
/// APIs (`showDialog`, `showModalBottomSheet`) require to work in tests.
///
/// Tap the button (`find.text(triggerLabel)`) to invoke [onPressed], then
/// `pumpAndSettle` to let the overlay animate in.
Future<void> pumpScopedApp(
  WidgetTester tester,
  void Function(BuildContext context) onPressed, {
  ProviderContainer? container,
  String triggerLabel = 'trigger',
}) async {
  Widget app = MaterialApp(
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
  );

  if (container != null) {
    app = UncontrolledProviderScope(container: container, child: app);
  }

  await tester.pumpWidget(app);
}
