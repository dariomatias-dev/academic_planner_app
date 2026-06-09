import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/categories/data/data_source/category_local_datasource.dart';
import 'package:academic_planner/src/features/categories/data/repositories/category_repository_impl.dart';
import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryLocalDataSource extends Mock
    implements CategoryLocalDataSource {}

void main() {
  late MockCategoryLocalDataSource mockDs;
  late CategoryRepositoryImpl sut;

  setUp(() {
    mockDs = MockCategoryLocalDataSource();
    sut = CategoryRepositoryImpl(mockDs);
  });

  group('CategoryRepositoryImpl.getCategories', () {
    test('empty storage → saves 5 defaults and returns them', () async {
      when(() => mockDs.getAll()).thenReturn([]);
      when(() => mockDs.saveAll(any())).thenAnswer((_) async {});

      final result = await sut.getCategories();

      expect(result, isA<Success<List<Category>>>());
      expect((result as Success<List<Category>>).value.length, 5);
      verify(() => mockDs.saveAll(any())).called(1);
    });

    test('non-empty storage → maps stored data to entities', () async {
      when(() => mockDs.getAll()).thenReturn([
        {'name': 'Math'},
        {'name': 'Science'},
        {'name': 'History'},
      ]);

      final result = await sut.getCategories();

      expect(result, isA<Success<List<Category>>>());
      final categories = (result as Success<List<Category>>).value;
      expect(categories.length, 3);
      expect(categories[0].name, 'Math');
      expect(categories[1].name, 'Science');
      expect(categories[2].name, 'History');
    });

    test('datasource throws → returns Failure', () async {
      when(() => mockDs.getAll()).thenThrow(Exception('storage error'));

      final result = await sut.getCategories();

      expect(result, isA<Failure<List<Category>>>());
    });
  });

  group('CategoryRepositoryImpl.saveCategories', () {
    test('success → returns Success and calls saveAll once', () async {
      when(() => mockDs.saveAll(any())).thenAnswer((_) async {});

      final result = await sut.saveCategories(const [
        Category(name: 'Art'),
        Category(name: 'Music'),
      ]);

      expect(result, isA<Success<void>>());
      verify(() => mockDs.saveAll(any())).called(1);
    });

    test('datasource throws → returns Failure', () async {
      when(() => mockDs.saveAll(any())).thenThrow(Exception('storage error'));

      final result = await sut.saveCategories(const [Category(name: 'X')]);

      expect(result, isA<Failure<void>>());
    });
  });
}
