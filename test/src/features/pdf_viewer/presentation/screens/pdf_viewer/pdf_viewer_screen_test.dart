import 'package:academic_planner/src/features/pdf_viewer/presentation/screens/pdf_viewer/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

Widget _harness() {
  return const MaterialApp(
    home: PdfViewerScreen(
      title: 'Plano de Ensino',
      url: 'https://example.com/plan.pdf',
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
    when(
      () => mockPlatform.launchUrl(any(), any()),
    ).thenAnswer((_) async => true);
  });

  group('PdfViewerScreen', () {
    testWidgets('renders the title and the open-externally action', (
      tester,
    ) async {
      await tester.pumpWidget(_harness());
      await tester.pump();

      expect(find.text('Plano de Ensino'), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new_rounded), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets(
      'document fails to load (no real network in tests) → shows the '
      'error state',
      (tester) async {
        await tester.pumpWidget(_harness());
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('Falha ao carregar'), findsOneWidget);
        expect(
          find.text(
            'Não foi possível abrir o documento. Verifique sua conexão '
            'com a internet.',
          ),
          findsOneWidget,
        );
        expect(find.text('Carregando documento...'), findsNothing);
      },
    );

    testWidgets('tapping retry goes back to loading before failing again', (
      tester,
    ) async {
      await tester.pumpWidget(_harness());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Falha ao carregar'), findsOneWidget);

      await tester.tap(find.text('Tentar novamente'));
      await tester.pump();

      expect(find.text('Carregando documento...'), findsOneWidget);
      expect(find.text('Falha ao carregar'), findsNothing);

      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Falha ao carregar'), findsOneWidget);
    });

    testWidgets('tapping the open-externally action launches the url', (
      tester,
    ) async {
      await tester.pumpWidget(_harness());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.open_in_new_rounded));
      await tester.pump();

      verify(
        () => mockPlatform.launchUrl('https://example.com/plan.pdf', any()),
      ).called(1);

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
