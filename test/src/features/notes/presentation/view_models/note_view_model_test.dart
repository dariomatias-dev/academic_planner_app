import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/domain/repositories/note_repository.dart';
import 'package:academic_planner/src/features/notes/presentation/view_models/note_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

Note _baseNote({String id = 'note-1'}) => Note(
  id: id,
  title: 'Calculus Notes',
  content: 'Derivatives and integrals',
  disciplineId: 1,
  createdAt: DateTime.parse('2024-01-01T00:00:00.000'),
  updatedAt: DateTime.parse('2024-01-01T00:00:00.000'),
);

void main() {
  late MockNoteRepository mockRepository;
  late NoteViewModel sut;

  setUpAll(() {
    registerFallbackValue(_baseNote());
  });

  setUp(() {
    mockRepository = MockNoteRepository();
    sut = NoteViewModel(mockRepository);
  });

  group('create', () {
    test('delegates to repository.add and returns its result', () async {
      final note = _baseNote();
      when(
        () => mockRepository.add(note),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.create(note);

      expect(result, isA<Success<void>>());
      verify(() => mockRepository.add(note)).called(1);
    });

    test('propagates failure from repository', () async {
      final note = _baseNote();
      when(() => mockRepository.add(note)).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('insert failed')),
      );

      final result = await sut.create(note);

      expect(result, isA<Failure<void>>());
    });
  });

  group('getAll', () {
    test('returns notes from repository', () async {
      final notes = [_baseNote()];
      when(
        () => mockRepository.getAll(),
      ).thenAnswer((_) async => Success<List<Note>>(notes));

      final result = await sut.getAll();

      result.when(
        onSuccess: (value) => expect(value, notes),
        onFailure: (_) => fail('expected success'),
      );
    });

    test('propagates failure from repository', () async {
      when(() => mockRepository.getAll()).thenAnswer(
        (_) async => const Failure<List<Note>>(DatabaseFailure('failed')),
      );

      final result = await sut.getAll();

      expect(result, isA<Failure<List<Note>>>());
    });
  });

  group('getById', () {
    test('returns note when found', () async {
      final note = _baseNote();
      when(
        () => mockRepository.getById('note-1'),
      ).thenAnswer((_) async => Success<Note?>(note));

      final result = await sut.getById('note-1');

      result.when(
        onSuccess: (value) => expect(value, note),
        onFailure: (_) => fail('expected success'),
      );
    });

    test('propagates failure from repository', () async {
      when(() => mockRepository.getById('missing')).thenAnswer(
        (_) async => const Failure<Note?>(DatabaseFailure('not found')),
      );

      final result = await sut.getById('missing');

      expect(result, isA<Failure<Note?>>());
    });
  });

  group('update', () {
    test('refreshes updatedAt before delegating to repository', () async {
      final note = _baseNote();
      when(
        () => mockRepository.update(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.update(note);

      expect(result, isA<Success<void>>());
      final captured =
          verify(() => mockRepository.update(captureAny())).captured.single
              as Note;
      expect(captured.id, note.id);
      expect(
        captured.updatedAt.isAfter(note.updatedAt) ||
            captured.updatedAt.isAtSameMomentAs(note.updatedAt),
        isTrue,
      );
    });

    test('propagates failure from repository', () async {
      when(() => mockRepository.update(any())).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('update failed')),
      );

      final result = await sut.update(_baseNote());

      expect(result, isA<Failure<void>>());
    });
  });

  group('delete', () {
    test('delegates to repository.delete', () async {
      when(
        () => mockRepository.delete('note-1'),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.delete('note-1');

      expect(result, isA<Success<void>>());
      verify(() => mockRepository.delete('note-1')).called(1);
    });

    test('propagates failure from repository', () async {
      when(() => mockRepository.delete('note-1')).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('delete failed')),
      );

      final result = await sut.delete('note-1');

      expect(result, isA<Failure<void>>());
    });
  });

  group('createNew', () {
    test('builds a Note with a generated id and matching timestamps', () {
      final note = sut.createNew(
        title: 'New Note',
        content: 'Some content',
        disciplineId: 3,
      );

      expect(note.id, isNotEmpty);
      expect(note.title, 'New Note');
      expect(note.content, 'Some content');
      expect(note.disciplineId, 3);
      expect(note.createdAt, note.updatedAt);
    });
  });
}
