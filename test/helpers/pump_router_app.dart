import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Pumps a full `MaterialApp.router` scoped to [container], for tests that
/// exercise routing/redirect behavior end to end rather than a single
/// screen in isolation.
///
/// Navigate with [router] (e.g. `router.go(path)`) *before* calling this,
/// so the first pumped frame already reflects the destination — otherwise
/// the very first frame builds whatever the router's `initialLocation` is.
Future<void> pumpRouterApp(
  WidgetTester tester,
  GoRouter router,
  ProviderContainer container,
) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
}
