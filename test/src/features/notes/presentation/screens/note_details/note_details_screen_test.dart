import 'dart:async';

import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/core/routes/route_names.dart';
import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/presentation/providers/note_notifier.dart';
import 'package:academic_planner/src/features/notes/presentation/screens/note_details/note_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeNoteNotifier extends NoteNotifier {
  _FakeNoteNotifier({this.onGetById});

  final Future<Result<Note?>> Function(String id)? onGetById;

  @override
  Future<void> build() async {}

  @override
  Future<Result<Note?>> getById(String id) {
    return onGetById?.call(id) ?? Future.value(const Success<Note?>(null));
  }
}

Note _note({int disciplineId = 14, String content = 'conteúdo da nota'}) =>
    Note(
      id: 'n1',
      title: 'Resumo da prova',
      content: content,
      disciplineId: disciplineId,
      createdAt: DateTime(2025),
      updatedAt: DateTime(2025),
    );

Future<ProviderContainer> _buildContainer({
  Future<Result<Note?>> Function(String id)? onGetById,
}) async {
  final container = ProviderContainer(
    overrides: [
      noteNotifierProvider.overrideWith(
        () => _FakeNoteNotifier(onGetById: onGetById),
      ),
    ],
  );

  await container.read(noteNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container, {String noteId = 'n1'}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => NoteDetailsScreen(noteId: noteId),
      ),
      GoRoute(
        path: '/note-form',
        name: RouteNames.noteForm,
        builder: (_, _) => const Text('NOTE_FORM_SCREEN'),
      ),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
    ),
  );
}

void main() {
  const fluttertoastChannel = MethodChannel('PonnamKarthik/fluttertoast');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(fluttertoastChannel, (_) async => true);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(fluttertoastChannel, null);
  });

  group('NoteDetailsScreen', () {
    testWidgets('fetch pending → shows the loading state', (tester) async {
      final completer = Completer<Result<Note?>>();

      final container = await _buildContainer(
        onGetById: (_) => completer.future,
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(Success<Note?>(_note()));
      await tester.pumpAndSettle();
    });

    testWidgets('note not found → shows the empty state', (tester) async {
      final container = await _buildContainer(
        onGetById: (_) async => const Success<Note?>(null),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Anotação não encontrada'), findsOneWidget);
    });

    testWidgets('fetch failure → shows the error state', (tester) async {
      final container = await _buildContainer(
        onGetById: (_) async => throw Exception('boom'),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Erro ao carregar'), findsOneWidget);
      expect(find.text('Tentar novamente'), findsOneWidget);
    });

    testWidgets('loaded note with a known discipline → renders the badge, '
        'title, content and discipline', (tester) async {
      final container = await _buildContainer(
        onGetById: (_) async => Success<Note?>(_note()),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pump(Duration.zero);
      await tester.pumpAndSettle();

      expect(find.text('ALGO'), findsOneWidget);
      expect(find.text('Resumo da prova'), findsWidgets);
      expect(
        find.text('conteúdo da nota', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.text('Algoritmos e Lógica de Programação'),
        findsOneWidget,
      );
    });

    testWidgets('loaded note with an unknown discipline → hides the '
        'discipline section', (tester) async {
      final container = await _buildContainer(
        onGetById: (_) async => Success<Note?>(_note(disciplineId: -1)),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pump(Duration.zero);
      await tester.pumpAndSettle();

      expect(find.text('DISCIPLINA'), findsNothing);
    });

    testWidgets('loaded note → opening the menu and tapping "Editar" '
        'navigates to the form', (tester) async {
      final container = await _buildContainer(
        onGetById: (_) async => Success<Note?>(_note()),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pump(Duration.zero);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();

      expect(find.text('NOTE_FORM_SCREEN'), findsOneWidget);
    });
  });
}
