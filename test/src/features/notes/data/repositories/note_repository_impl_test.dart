import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/notes/data/data_source/note_local_datasource.dart';
import 'package:academic_planner/src/features/notes/data/repositories/note_repository_impl.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNoteLocalDataSource extends Mock implements NoteLocalDataSource {}

Note _baseNote({String id = 'note-1'}) => Note(
  id: id,
  title: 'Calculus Notes',
  content: 'Derivatives and integrals',
  disciplineId: 1,
  createdAt: DateTime.parse('2024-01-01T00:00:00.000'),
  updatedAt: DateTime.parse('2024-01-01T00:00:00.000'),
);

Map<String, dynamic> _noteRow({String id = 'note-1'}) => {
  'id': id,
  'title': 'Calculus Notes',
  'content': 'Derivatives and integrals',
  'disciplineId': 1,
  'createdAt': '2024-01-01T00:00:00.000',
  'updatedAt': '2024-01-01T00:00:00.000',
};

void main() {
  late MockNoteLocalDataSource mockDs;
  late NoteRepositoryImpl sut;

  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  setUp(() {
    mockDs = MockNoteLocalDataSource();
    sut = NoteRepositoryImpl(mockDs);
  });

  group('add', () {
    test('success → returns Success', () async {
      when(() => mockDs.insert(any())).thenAnswer((_) async {});

      final result = await sut.add(_baseNote());

      expect(result, isA<Success<void>>());
      verify(() => mockDs.insert(any())).called(1);
    });

    test('exception → returns Failure', () async {
      when(() => mockDs.insert(any())).thenThrow(Exception('db error'));

      final result = await sut.add(_baseNote());

      expect(result, isA<Failure<void>>());
    });
  });

  group('getAll', () {
    test('empty result → Success with empty list', () async {
      when(() => mockDs.getAll()).thenAnswer((_) async => []);

      final result = await sut.getAll();

      expect(result, isA<Success<List<Note>>>());
      expect((result as Success<List<Note>>).value, isEmpty);
    });

    test('rows returned → Success with mapped notes', () async {
      when(
        () => mockDs.getAll(),
      ).thenAnswer((_) async => [_noteRow(id: '1'), _noteRow(id: '2')]);

      final result = await sut.getAll();

      expect(result, isA<Success<List<Note>>>());
      expect((result as Success<List<Note>>).value.length, 2);
    });

    test('exception → returns Failure', () async {
      when(() => mockDs.getAll()).thenThrow(Exception('db error'));

      final result = await sut.getAll();

      expect(result, isA<Failure<List<Note>>>());
    });
  });

  group('getById', () {
    test('row found → Success with mapped note', () async {
      when(() => mockDs.getById(any())).thenAnswer((_) async => _noteRow());

      final result = await sut.getById('note-1');

      expect(result, isA<Success<Note?>>());
      expect((result as Success<Note?>).value?.id, 'note-1');
    });

    test('null returned → Success(null)', () async {
      when(() => mockDs.getById(any())).thenAnswer((_) async => null);

      final result = await sut.getById('no-such-id');

      expect(result, isA<Success<Note?>>());
      expect((result as Success<Note?>).value, isNull);
    });

    test('exception → returns Failure', () async {
      when(() => mockDs.getById(any())).thenThrow(Exception('db error'));

      final result = await sut.getById('note-1');

      expect(result, isA<Failure<Note?>>());
    });
  });

  group('update', () {
    test('success → returns Success', () async {
      when(() => mockDs.update(any(), any())).thenAnswer((_) async {});

      final result = await sut.update(_baseNote());

      expect(result, isA<Success<void>>());
      verify(() => mockDs.update('note-1', any())).called(1);
    });

    test('exception → returns Failure', () async {
      when(() => mockDs.update(any(), any())).thenThrow(Exception('db error'));

      final result = await sut.update(_baseNote());

      expect(result, isA<Failure<void>>());
    });
  });

  group('delete', () {
    test('success → returns Success', () async {
      when(() => mockDs.delete(any())).thenAnswer((_) async {});

      final result = await sut.delete('note-1');

      expect(result, isA<Success<void>>());
      verify(() => mockDs.delete('note-1')).called(1);
    });

    test('exception → returns Failure', () async {
      when(() => mockDs.delete(any())).thenThrow(Exception('db error'));

      final result = await sut.delete('note-1');

      expect(result, isA<Failure<void>>());
    });
  });
}
