import 'package:academic_planner/src/features/teacher/presentation/screens/teacher_details/teacher_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

Widget _harness(int teacherId) {
  return MaterialApp(home: TeacherDetailsScreen(teacherId: teacherId));
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

  group('TeacherDetailsScreen', () {
    testWidgets('known teacher → renders header and the populated '
        'sections only', (tester) async {
      await tester.pumpWidget(_harness(2));
      await tester.pumpAndSettle();

      expect(find.text('Fernanda Costa Ribeiro'), findsOneWidget);
      expect(find.text('FORMAÇÃO ACADÊMICA'), findsOneWidget);
      expect(
        find.text('Doutorado em Administração (em andamento)'),
        findsNWidgets(2),
      );
      expect(find.text('PÓS-GRADUAÇÃO'), findsOneWidget);
      expect(find.text('Direito Educacional'), findsOneWidget);
      expect(find.text('PÓS-DOUTORADO'), findsNothing);
      expect(find.text('FORMAÇÃO COMPLEMENTAR'), findsNothing);
    });

    testWidgets('unknown teacher → shows the empty state', (tester) async {
      await tester.pumpWidget(_harness(-1));
      await tester.pumpAndSettle();

      expect(find.text('Docente não encontrado'), findsOneWidget);
      expect(find.text('Voltar'), findsOneWidget);
    });

    testWidgets('tapping "Voltar" on the empty state pops the screen', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) =>
                            const TeacherDetailsScreen(teacherId: -1),
                      ),
                    );
                  },
                  child: const Text('open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Voltar'));
      await tester.pumpAndSettle();

      expect(find.text('Docente não encontrado'), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });

    testWidgets('tapping the launch action opens the lattes url', (
      tester,
    ) async {
      await tester.pumpWidget(_harness(2));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.launch_rounded));
      await tester.pumpAndSettle();

      verify(
        () => mockPlatform.launchUrl(
          'http://lattes.cnpq.br/0000000000000002',
          any(),
        ),
      ).called(1);
    });
  });
}
