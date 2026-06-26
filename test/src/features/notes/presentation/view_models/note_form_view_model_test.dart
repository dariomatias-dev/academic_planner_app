import 'dart:convert';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/domain/repositories/note_repository.dart';
import 'package:academic_planner/src/features/notes/presentation/view_models/note_form_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

String _encodeContent(String text) => jsonEncode([
  {'insert': '$text\n'},
]);

Note _note({
  String id = 'note-1',
  String title = 'Calculus Notes',
  String content = '',
  int disciplineId = 15,
}) => Note(
  id: id,
  title: title,
  content: content.isEmpty ? _encodeContent('') : content,
  disciplineId: disciplineId,
  createdAt: DateTime.parse('2024-01-01T00:00:00.000'),
  updatedAt: DateTime.parse('2024-01-01T00:00:00.000'),
);

void main() {
  late MockNoteRepository mockRepository;
  late ProviderContainer container;
  late NoteFormViewModel sut;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(_note());
  });

  setUp(() async {
    mockRepository = MockNoteRepository();
    container = ProviderContainer(
      overrides: [noteRepositoryProvider.overrideWithValue(mockRepository)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(noteNotifierProvider.notifier);
    await container.read(noteNotifierProvider.future);

    sut = NoteFormViewModel(notifier);
    addTearDown(sut.dispose);
  });

  group('load - new note', () {
    test('sets discipline from disciplineId', () async {
      final result = await sut.load(noteId: null, disciplineId: 15);

      expect(result, isA<Success<void>>());
      expect(sut.discipline.value?.id, 15);
      expect(sut.canSave.value, isTrue);
    });

    test('unknown disciplineId leaves discipline unset', () async {
      final result = await sut.load(noteId: null, disciplineId: -1);

      expect(result, isA<Success<void>>());
      expect(sut.discipline.value, isNull);
    });
  });

  group('load - existing note', () {
    test('success populates fields and marks canSave false', () async {
      final note = _note(
        title: 'Study Notes',
        content: _encodeContent('Hello'),
      );
      when(
        () => mockRepository.getById('note-1'),
      ).thenAnswer((_) async => Success<Note?>(note));

      final result = await sut.load(noteId: 'note-1', disciplineId: 15);

      expect(result, isA<Success<void>>());
      expect(sut.titleController.text, 'Study Notes');
      expect(sut.discipline.value?.id, 15);
      expect(sut.isLoading.value, isFalse);
      expect(sut.canSave.value, isFalse);
    });

    test('note not found leaves canSave true and form untouched', () async {
      when(
        () => mockRepository.getById('missing'),
      ).thenAnswer((_) async => const Success<Note?>(null));

      final result = await sut.load(noteId: 'missing', disciplineId: 15);

      expect(result, isA<Success<void>>());
      expect(sut.titleController.text, isEmpty);
      expect(sut.isLoading.value, isFalse);
    });

    test('repository failure returns Failure', () async {
      when(() => mockRepository.getById('note-1')).thenAnswer(
        (_) async => const Failure<Note?>(DatabaseFailure('not found')),
      );

      final result = await sut.load(noteId: 'note-1', disciplineId: 15);

      expect(result, isA<Failure<void>>());
      expect(sut.isLoading.value, isFalse);
    });

    test('malformed content JSON is handled without throwing', () async {
      final note = _note(content: 'not-json');
      when(
        () => mockRepository.getById('note-1'),
      ).thenAnswer((_) async => Success<Note?>(note));

      final result = await sut.load(noteId: 'note-1', disciplineId: 15);

      expect(result, isA<Success<void>>());
    });
  });

  group('save', () {
    test('without initial note creates and adds a new one', () async {
      when(
        () => mockRepository.add(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      await sut.load(noteId: null, disciplineId: 15);
      sut.titleController.text = 'New note';

      final result = await sut.save();

      expect(result, isA<Success<void>>());
      final captured =
          verify(() => mockRepository.add(captureAny())).captured.single
              as Note;
      expect(captured.title, 'New note');
      expect(captured.disciplineId, 15);
    });

    test('with initial note updates it via the notifier', () async {
      final note = _note();
      when(
        () => mockRepository.getById('note-1'),
      ).thenAnswer((_) async => Success<Note?>(note));
      when(
        () => mockRepository.update(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      await sut.load(noteId: 'note-1', disciplineId: 15);
      sut.titleController.text = 'Updated note';

      final result = await sut.save();

      expect(result, isA<Success<void>>());
      final captured =
          verify(() => mockRepository.update(captureAny())).captured.single
              as Note;
      expect(captured.id, 'note-1');
      expect(captured.title, 'Updated note');
    });

    test('propagates repository failure on create', () async {
      when(() => mockRepository.add(any())).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('insert failed')),
      );
      await sut.load(noteId: null, disciplineId: 15);
      sut.titleController.text = 'New note';

      final result = await sut.save();

      expect(result, isA<Failure<void>>());
    });
  });

  group('setDiscipline', () {
    test('updates discipline and marks as changed for a loaded note', () async {
      final note = _note();
      when(
        () => mockRepository.getById('note-1'),
      ).thenAnswer((_) async => Success<Note?>(note));
      await sut.load(noteId: 'note-1', disciplineId: 15);

      sut.setDiscipline(adsDisciplines.firstWhere((d) => d.id == 14));

      expect(sut.discipline.value?.id, 14);
      expect(sut.canSave.value, isTrue);
    });
  });

  group('hasChanges', () {
    test('is true for a brand-new note with no edits', () async {
      await sut.load(noteId: null, disciplineId: 15);

      expect(sut.hasChanges(), isTrue);
    });

    test('is false right after loading an unmodified note', () async {
      final note = _note();
      when(
        () => mockRepository.getById('note-1'),
      ).thenAnswer((_) async => Success<Note?>(note));
      await sut.load(noteId: 'note-1', disciplineId: 15);

      expect(sut.hasChanges(), isFalse);
    });

    test('is true after editing the title of a loaded note', () async {
      final note = _note();
      when(
        () => mockRepository.getById('note-1'),
      ).thenAnswer((_) async => Success<Note?>(note));
      await sut.load(noteId: 'note-1', disciplineId: 15);

      sut.titleController.text = 'Changed title';

      expect(sut.hasChanges(), isTrue);
    });
  });
}
