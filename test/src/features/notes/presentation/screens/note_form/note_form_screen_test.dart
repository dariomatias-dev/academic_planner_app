import 'dart:convert';

import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/presentation/providers/note_notifier.dart';
import 'package:academic_planner/src/features/notes/presentation/screens/note_form/note_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeNoteNotifier extends NoteNotifier {
  _FakeNoteNotifier({this.onGetById, this.onEdit, this.onAdd});

  final Future<Result<Note?>> Function(String id)? onGetById;
  final Future<Result<void>> Function(Note note)? onEdit;
  final Future<Result<void>> Function(Note note)? onAdd;

  @override
  Future<void> build() async {}

  @override
  Future<Result<Note?>> getById(String id) {
    return onGetById?.call(id) ?? Future.value(const Success<Note?>(null));
  }

  @override
  Future<Result<void>> edit(Note note) {
    return onEdit?.call(note) ?? Future.value(const Success<void>(null));
  }

  @override
  Future<Result<void>> add(Note note) {
    return onAdd?.call(note) ?? Future.value(const Success<void>(null));
  }

  @override
  Note createNew({
    required String title,
    required String content,
    required int disciplineId,
  }) {
    return Note(
      id: 'new-id',
      title: title,
      content: content,
      disciplineId: disciplineId,
    );
  }
}

String _quillContent(String text) {
  return jsonEncode([
    {'insert': '$text\n'},
  ]);
}

Note _note({String title = 'Resumo da prova', String? content}) => Note(
  id: 'n1',
  title: title,
  content: content ?? _quillContent('conteúdo da nota'),
  disciplineId: 14,
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);

Future<ProviderContainer> _buildContainer({
  Future<Result<Note?>> Function(String id)? onGetById,
  Future<Result<void>> Function(Note note)? onEdit,
  Future<Result<void>> Function(Note note)? onAdd,
}) async {
  final container = ProviderContainer(
    overrides: [
      noteNotifierProvider.overrideWith(
        () => _FakeNoteNotifier(
          onGetById: onGetById,
          onEdit: onEdit,
          onAdd: onAdd,
        ),
      ),
    ],
  );

  await container.read(noteNotifierProvider.future);

  return container;
}

class _Harness extends StatelessWidget {
  const _Harness({required this.noteId, required this.disciplineId});

  final String? noteId;
  final int disciplineId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => NoteFormScreen(
                    noteId: noteId,
                    disciplineId: disciplineId,
                  ),
                ),
              );
            },
            child: const Text('open'),
          );
        },
      ),
    );
  }
}

Widget _wrap(ProviderContainer container, Widget child) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      home: child,
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

  Future<void> openForm(WidgetTester tester) async {
    await tester.tap(find.text('open'));
    await tester.pump(Duration.zero);
    await tester.pumpAndSettle();
  }

  group('NoteFormScreen (new note)', () {
    testWidgets('renders the empty form with the save button enabled', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _wrap(container, const _Harness(noteId: null, disciplineId: 14)),
      );
      await openForm(tester);

      expect(find.text('Nova Anotação'), findsOneWidget);

      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.check_rounded),
          matching: find.byType(IconButton),
        ),
      );
      expect(iconButton.onPressed, isNotNull);
    });

    testWidgets('saving an empty form shows validation errors', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _wrap(container, const _Harness(noteId: null, disciplineId: 14)),
      );
      await openForm(tester);

      await tester.tap(find.byIcon(Icons.check_rounded));
      await tester.pumpAndSettle();

      expect(find.text('O título é obrigatório'), findsOneWidget);
      expect(find.text('Nova Anotação'), findsOneWidget);
    });
  });

  group('NoteFormScreen (editing)', () {
    testWidgets('loads the note and shows the save button disabled', (
      tester,
    ) async {
      final container = await _buildContainer(
        onGetById: (_) async => Success<Note?>(_note()),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _wrap(container, const _Harness(noteId: 'n1', disciplineId: 14)),
      );
      await openForm(tester);

      expect(find.text('Editar Anotação'), findsOneWidget);
      expect(find.text('Resumo da prova'), findsOneWidget);

      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.check_rounded),
          matching: find.byType(IconButton),
        ),
      );
      expect(iconButton.onPressed, isNull);
    });

    testWidgets('editing the title enables save; saving persists and pops '
        'true', (tester) async {
      Note? savedNote;

      final container = await _buildContainer(
        onGetById: (_) async => Success<Note?>(_note()),
        onEdit: (note) async {
          savedNote = note;

          return const Success<void>(null);
        },
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _wrap(container, const _Harness(noteId: 'n1', disciplineId: 14)),
      );
      await openForm(tester);

      await tester.enterText(
        find.byType(TextFormField).first,
        'Resumo da prova 2',
      );
      await tester.pumpAndSettle();

      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.check_rounded),
          matching: find.byType(IconButton),
        ),
      );
      expect(iconButton.onPressed, isNotNull);

      await tester.tap(find.byIcon(Icons.check_rounded));
      await tester.pumpAndSettle();

      expect(savedNote?.title, 'Resumo da prova 2');
      expect(find.text('Editar Anotação'), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });

    testWidgets('fetch failure → shows a toast and keeps the form usable', (
      tester,
    ) async {
      final container = await _buildContainer(
        onGetById: (_) async => const Failure<Note?>(UnknownFailure('boom')),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _wrap(container, const _Harness(noteId: 'n1', disciplineId: 14)),
      );
      await openForm(tester);
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Editar Anotação'), findsOneWidget);
    });
  });
}
