import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/tags/data/data_source/tag_local_datasource.dart';
import 'package:academic_planner/src/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTagLocalDataSource extends Mock implements TagLocalDataSource {}

void main() {
  late MockTagLocalDataSource mockDs;
  late TagRepositoryImpl sut;

  setUp(() {
    mockDs = MockTagLocalDataSource();
    sut = TagRepositoryImpl(mockDs);
  });

  group('TagRepositoryImpl.getTags', () {
    test('empty storage → saves 4 defaults and returns them', () async {
      when(() => mockDs.getAll()).thenReturn([]);
      when(() => mockDs.saveAll(any())).thenAnswer((_) async {});

      final result = await sut.getTags();

      expect(result, isA<Success<List<Tag>>>());
      expect((result as Success<List<Tag>>).value.length, 4);
      verify(() => mockDs.saveAll(any())).called(1);
    });

    test('non-empty storage → maps stored data to entities', () async {
      when(() => mockDs.getAll()).thenReturn([
        {'name': 'Urgente'},
        {'name': 'Grupo'},
      ]);

      final result = await sut.getTags();

      expect(result, isA<Success<List<Tag>>>());
      final tags = (result as Success<List<Tag>>).value;
      expect(tags.length, 2);
      expect(tags[0].name, 'Urgente');
      expect(tags[1].name, 'Grupo');
    });

    test('datasource throws → returns Failure', () async {
      when(() => mockDs.getAll()).thenThrow(Exception('storage error'));

      final result = await sut.getTags();

      expect(result, isA<Failure<List<Tag>>>());
    });
  });

  group('TagRepositoryImpl.saveTags', () {
    test('success → returns Success and calls saveAll once', () async {
      when(() => mockDs.saveAll(any())).thenAnswer((_) async {});

      final result = await sut.saveTags(const [
        Tag(name: 'Flutter'),
        Tag(name: 'Dart'),
      ]);

      expect(result, isA<Success<void>>());
      verify(() => mockDs.saveAll(any())).called(1);
    });

    test('datasource throws → returns Failure', () async {
      when(() => mockDs.saveAll(any())).thenThrow(Exception('storage error'));

      final result = await sut.saveTags(const [Tag(name: 'X')]);

      expect(result, isA<Failure<void>>());
    });
  });
}
