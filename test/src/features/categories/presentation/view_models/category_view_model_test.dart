import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:academic_planner/src/features/categories/domain/repositories/category_repository.dart';
import 'package:academic_planner/src/features/categories/presentation/view_models/category_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

List<String> _names(List<Category> categories) =>
    categories.map((c) => c.name).toList();

void main() {
  late MockCategoryRepository mockRepository;
  late CategoryViewModel sut;

  setUpAll(() {
    registerFallbackValue(<Category>[]);
  });

  setUp(() {
    mockRepository = MockCategoryRepository();
    sut = CategoryViewModel(mockRepository);
  });

  group('load', () {
    test('returns categories from repository', () async {
      final categories = [const Category(name: 'Exams')];
      when(
        () => mockRepository.getCategories(),
      ).thenAnswer((_) async => Success<List<Category>>(categories));

      final result = await sut.load();

      result.when(
        onSuccess: (value) => expect(value, categories),
        onFailure: (_) => fail('expected success'),
      );
    });

    test('propagates failure from repository', () async {
      when(() => mockRepository.getCategories()).thenAnswer(
        (_) async =>
            const Failure<List<Category>>(DatabaseFailure('load failed')),
      );

      final result = await sut.load();

      expect(result, isA<Failure<List<Category>>>());
    });
  });

  group('add', () {
    test('appends new category and saves it', () async {
      const current = [Category(name: 'Exams')];
      when(
        () => mockRepository.saveCategories(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.add(current, 'Homework');

      result.when(
        onSuccess: (value) => expect(_names(value), ['Exams', 'Homework']),
        onFailure: (_) => fail('expected success'),
      );
      final captured =
          verify(
                () => mockRepository.saveCategories(captureAny()),
              ).captured.single
              as List<Category>;
      expect(_names(captured), ['Exams', 'Homework']);
    });

    test('rejects a duplicate name case-insensitively', () async {
      const current = [Category(name: 'Exams')];

      final result = await sut.add(current, 'exams');

      expect(result, isA<Failure<List<Category>>>());
      result.when(
        onSuccess: (_) => fail('expected failure'),
        onFailure: (f) => expect(f, isA<ValidationFailure>()),
      );
      verifyNever(() => mockRepository.saveCategories(any()));
    });

    test('propagates failure from repository', () async {
      const current = <Category>[];
      when(() => mockRepository.saveCategories(any())).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('save failed')),
      );

      final result = await sut.add(current, 'Homework');

      expect(result, isA<Failure<List<Category>>>());
    });
  });

  group('update', () {
    test('renames the category at the given index', () async {
      const current = [Category(name: 'Exams'), Category(name: 'Homework')];
      when(
        () => mockRepository.saveCategories(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.update(current, 1, 'Assignments');

      result.when(
        onSuccess: (value) => expect(_names(value), ['Exams', 'Assignments']),
        onFailure: (_) => fail('expected success'),
      );
    });

    test('rejects a name already used by another entry', () async {
      const current = [Category(name: 'Exams'), Category(name: 'Homework')];

      final result = await sut.update(current, 1, 'exams');

      expect(result, isA<Failure<List<Category>>>());
      verifyNever(() => mockRepository.saveCategories(any()));
    });

    test('allows renaming to its own current name', () async {
      const current = [Category(name: 'Exams'), Category(name: 'Homework')];
      when(
        () => mockRepository.saveCategories(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.update(current, 1, 'Homework');

      expect(result, isA<Success<List<Category>>>());
    });

    test('propagates failure from repository', () async {
      const current = [Category(name: 'Exams')];
      when(() => mockRepository.saveCategories(any())).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('save failed')),
      );

      final result = await sut.update(current, 0, 'Renamed');

      expect(result, isA<Failure<List<Category>>>());
    });
  });

  group('remove', () {
    test(
      'removes the category at the given index and saves the rest',
      () async {
        const current = [
          Category(name: 'Exams'),
          Category(name: 'Homework'),
        ];
        when(
          () => mockRepository.saveCategories(any()),
        ).thenAnswer((_) async => const Success<void>(null));

        final result = await sut.remove(current, 0);

        result.when(
          onSuccess: (value) => expect(_names(value), ['Homework']),
          onFailure: (_) => fail('expected success'),
        );
      },
    );

    test('propagates failure from repository', () async {
      const current = [Category(name: 'Exams')];
      when(() => mockRepository.saveCategories(any())).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('save failed')),
      );

      final result = await sut.remove(current, 0);

      expect(result, isA<Failure<List<Category>>>());
    });
  });
}
