import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/domain/repositories/note_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

Note _note({String id = '1'}) => Note(
  id: id,
  title: 'Title',
  content: 'Content',
  disciplineId: 1,
);

void main() {
  late MockNoteRepository mockRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_note());
  });

  setUp(() {
    mockRepository = MockNoteRepository();
    container = ProviderContainer(
      overrides: [noteRepositoryProvider.overrideWithValue(mockRepository)],
    );
    addTearDown(container.dispose);
  });

  Future<void> readyNotifier() async {
    container.read(noteNotifierProvider.notifier);
    await container.read(noteNotifierProvider.future);
  }

  group('add', () {
    test('success → state settles to AsyncData(null)', () async {
      when(
        () => mockRepository.add(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      await readyNotifier();

      final result = await container
          .read(noteNotifierProvider.notifier)
          .add(_note());

      expect(result, isA<Success<void>>());
      expect(
        container.read(noteNotifierProvider),
        const AsyncData<void>(null),
      );
    });

    test(
      'failure → returns Failure but state still settles to AsyncData',
      () async {
        when(() => mockRepository.add(any())).thenAnswer(
          (_) async => const Failure<void>(DatabaseFailure('boom')),
        );
        await readyNotifier();

        final result = await container
            .read(noteNotifierProvider.notifier)
            .add(_note());

        expect(result, isA<Failure<void>>());
        expect(
          container.read(noteNotifierProvider),
          const AsyncData<void>(null),
        );
      },
    );
  });

  group('edit', () {
    test('success → returns Success', () async {
      when(
        () => mockRepository.update(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      await readyNotifier();

      final result = await container
          .read(noteNotifierProvider.notifier)
          .edit(_note());

      expect(result, isA<Success<void>>());
      expect(
        container.read(noteNotifierProvider),
        const AsyncData<void>(null),
      );
    });

    test('failure → returns Failure', () async {
      when(() => mockRepository.update(any())).thenAnswer(
        (_) async => const Failure<void>(ValidationFailure('invalid')),
      );
      await readyNotifier();

      final result = await container
          .read(noteNotifierProvider.notifier)
          .edit(_note());

      expect(result, isA<Failure<void>>());
    });
  });

  group('delete', () {
    test('success → returns Success', () async {
      when(
        () => mockRepository.delete(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      await readyNotifier();

      final result = await container
          .read(noteNotifierProvider.notifier)
          .delete('1');

      expect(result, isA<Success<void>>());
    });

    test('failure → returns Failure', () async {
      when(() => mockRepository.delete(any())).thenAnswer(
        (_) async => const Failure<void>(UnknownFailure('boom')),
      );
      await readyNotifier();

      final result = await container
          .read(noteNotifierProvider.notifier)
          .delete('1');

      expect(result, isA<Failure<void>>());
    });
  });

  group('getAll', () {
    test('delegates to repository', () async {
      final notes = [_note()];
      when(
        () => mockRepository.getAll(),
      ).thenAnswer((_) async => Success<List<Note>>(notes));
      await readyNotifier();

      final result = await container
          .read(noteNotifierProvider.notifier)
          .getAll();

      result.when(
        onSuccess: (value) => expect(value, notes),
        onFailure: (_) => fail('expected success'),
      );
    });
  });

  group('getById', () {
    test('delegates to repository', () async {
      final note = _note(id: 'abc');
      when(
        () => mockRepository.getById('abc'),
      ).thenAnswer((_) async => Success<Note?>(note));
      await readyNotifier();

      final result = await container
          .read(noteNotifierProvider.notifier)
          .getById('abc');

      result.when(
        onSuccess: (value) => expect(value, same(note)),
        onFailure: (_) => fail('expected success'),
      );
    });
  });

  group('createNew', () {
    test('builds a Note with the given fields and a generated id', () async {
      await readyNotifier();

      final note = container.read(noteNotifierProvider.notifier).createNew(
        title: 'Study',
        content: 'Review chapter 1',
        disciplineId: 3,
      );

      expect(note.id, isNotEmpty);
      expect(note.title, 'Study');
      expect(note.content, 'Review chapter 1');
      expect(note.disciplineId, 3);
    });
  });
}
