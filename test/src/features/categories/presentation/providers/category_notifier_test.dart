import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:academic_planner/src/features/categories/domain/repositories/category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late MockCategoryRepository mockRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(<Category>[]);
  });

  setUp(() {
    mockRepository = MockCategoryRepository();
    container = ProviderContainer(
      overrides: [
        categoryRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  group('build', () {
    test('loads categories from the repository', () async {
      const categories = [Category(name: 'Math')];
      when(
        () => mockRepository.getCategories(),
      ).thenAnswer((_) async => const Success(categories));

      final state = await container.read(categoryNotifierProvider.future);

      expect(state, categories);
    });

    test('repository failure → resolves to an empty list', () async {
      when(() => mockRepository.getCategories()).thenAnswer(
        (_) async => const Failure(DatabaseFailure('boom')),
      );

      final state = await container.read(categoryNotifierProvider.future);

      expect(state, isEmpty);
    });
  });

  group('add', () {
    test('new name → appends and persists', () async {
      when(
        () => mockRepository.getCategories(),
      ).thenAnswer((_) async => const Success([Category(name: 'Math')]));
      when(
        () => mockRepository.saveCategories(any()),
      ).thenAnswer((_) async => const Success(null));
      await container.read(categoryNotifierProvider.future);

      final result = await container
          .read(categoryNotifierProvider.notifier)
          .add('Physics');

      result.when(
        onSuccess: (value) {
          expect(value.map((c) => c.name), ['Math', 'Physics']);
        },
        onFailure: (_) => fail('expected success'),
      );
      expect(
        container.read(categoryNotifierProvider).value!.map((c) => c.name),
        ['Math', 'Physics'],
      );
    });

    test('duplicate name → Failure and state unchanged', () async {
      when(
        () => mockRepository.getCategories(),
      ).thenAnswer((_) async => const Success([Category(name: 'Math')]));
      await container.read(categoryNotifierProvider.future);

      final result = await container
          .read(categoryNotifierProvider.notifier)
          .add('math');

      expect(result, isA<Failure<List<Category>>>());
      verifyNever(() => mockRepository.saveCategories(any()));
    });
  });

  group('edit', () {
    test('updates the category at the given index', () async {
      when(() => mockRepository.getCategories()).thenAnswer(
        (_) async =>
            const Success([Category(name: 'Math'), Category(name: 'Physics')]),
      );
      when(
        () => mockRepository.saveCategories(any()),
      ).thenAnswer((_) async => const Success(null));
      await container.read(categoryNotifierProvider.future);

      final result = await container
          .read(categoryNotifierProvider.notifier)
          .edit(0, 'Calculus');

      result.when(
        onSuccess: (value) {
          expect(value.map((c) => c.name), ['Calculus', 'Physics']);
        },
        onFailure: (_) => fail('expected success'),
      );
    });
  });

  group('remove', () {
    test('removes the category at the given index', () async {
      when(() => mockRepository.getCategories()).thenAnswer(
        (_) async =>
            const Success([Category(name: 'Math'), Category(name: 'Physics')]),
      );
      when(
        () => mockRepository.saveCategories(any()),
      ).thenAnswer((_) async => const Success(null));
      await container.read(categoryNotifierProvider.future);

      final result = await container
          .read(categoryNotifierProvider.notifier)
          .remove(0);

      result.when(
        onSuccess: (value) => expect(value.map((c) => c.name), ['Physics']),
        onFailure: (_) => fail('expected success'),
      );
    });
  });
}
