import 'package:academic_planner/src/shared/utils/open_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

Widget _harness(Future<void> Function(BuildContext context) onPressed) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () => onPressed(context),
            child: const Text('trigger'),
          );
        },
      ),
    ),
  );
}

void main() {
  late _MockUrlLauncherPlatform mockPlatform;

  setUpAll(() {
    registerFallbackValue(const LaunchOptions());
  });

  setUp(() {
    mockPlatform = _MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = mockPlatform;
  });

  group('openUrl', () {
    testWidgets('launch succeeds → does not show the failure dialog', (
      tester,
    ) async {
      when(
        () => mockPlatform.launchUrl(any(), any()),
      ).thenAnswer((_) async => true);

      await tester.pumpWidget(
        _harness((context) => openUrl(context, 'https://example.com')),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      verify(
        () => mockPlatform.launchUrl('https://example.com', any()),
      ).called(1);
      expect(find.text('Não foi possível abrir'), findsNothing);
    });

    testWidgets('launch returns false → shows the failure dialog', (
      tester,
    ) async {
      when(
        () => mockPlatform.launchUrl(any(), any()),
      ).thenAnswer((_) async => false);

      await tester.pumpWidget(
        _harness((context) => openUrl(context, 'https://example.com')),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Não foi possível abrir'), findsOneWidget);
    });

    testWidgets('launch throws → shows the failure dialog', (tester) async {
      when(
        () => mockPlatform.launchUrl(any(), any()),
      ).thenThrow(Exception('boom'));

      await tester.pumpWidget(
        _harness((context) => openUrl(context, 'https://example.com')),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Não foi possível abrir'), findsOneWidget);
    });

    testWidgets('failure dialog can be dismissed', (tester) async {
      when(
        () => mockPlatform.launchUrl(any(), any()),
      ).thenAnswer((_) async => false);

      await tester.pumpWidget(
        _harness((context) => openUrl(context, 'https://example.com')),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();

      expect(find.text('Não foi possível abrir'), findsNothing);
    });
  });
}
