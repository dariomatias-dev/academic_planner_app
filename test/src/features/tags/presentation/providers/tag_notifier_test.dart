import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/domain/repositories/tag_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTagRepository extends Mock implements TagRepository {}

void main() {
  late MockTagRepository mockRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(<Tag>[]);
  });

  setUp(() {
    mockRepository = MockTagRepository();
    container = ProviderContainer(
      // build() throws on failure; disable Riverpod's default retry-with-
      // backoff so the failing-build test settles immediately.
      retry: (_, _) => null,
      overrides: [tagRepositoryProvider.overrideWithValue(mockRepository)],
    );
    addTearDown(container.dispose);
  });

  group('build', () {
    test('loads tags from the repository', () async {
      const tags = [Tag(name: 'urgent')];
      when(
        () => mockRepository.getTags(),
      ).thenAnswer((_) async => const Success(tags));

      final state = await container.read(tagNotifierProvider.future);

      expect(state, tags);
    });

    test('repository failure → notifier throws', () async {
      when(
        () => mockRepository.getTags(),
      ).thenAnswer((_) async => const Failure(DatabaseFailure('boom')));

      await expectLater(
        container.read(tagNotifierProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('add', () {
    test('new name → appends and persists', () async {
      when(
        () => mockRepository.getTags(),
      ).thenAnswer((_) async => const Success([Tag(name: 'urgent')]));
      when(
        () => mockRepository.saveTags(any()),
      ).thenAnswer((_) async => const Success(null));
      await container.read(tagNotifierProvider.future);

      final result = await container
          .read(tagNotifierProvider.notifier)
          .add('important');

      result.when(
        onSuccess: (value) {
          expect(value.map((t) => t.name), ['urgent', 'important']);
        },
        onFailure: (_) => fail('expected success'),
      );
    });

    test('duplicate name → Failure and does not persist', () async {
      when(
        () => mockRepository.getTags(),
      ).thenAnswer((_) async => const Success([Tag(name: 'urgent')]));
      await container.read(tagNotifierProvider.future);

      final result = await container
          .read(tagNotifierProvider.notifier)
          .add('URGENT');

      expect(result, isA<Failure<List<Tag>>>());
      verifyNever(() => mockRepository.saveTags(any()));
    });
  });

  group('edit', () {
    test('updates the tag at the given index', () async {
      when(() => mockRepository.getTags()).thenAnswer(
        (_) async => const Success([Tag(name: 'urgent'), Tag(name: 'easy')]),
      );
      when(
        () => mockRepository.saveTags(any()),
      ).thenAnswer((_) async => const Success(null));
      await container.read(tagNotifierProvider.future);

      final result = await container
          .read(tagNotifierProvider.notifier)
          .edit(0, 'critical');

      result.when(
        onSuccess: (value) {
          expect(value.map((t) => t.name), ['critical', 'easy']);
        },
        onFailure: (_) => fail('expected success'),
      );
    });
  });

  group('remove', () {
    test('removes the tag at the given index', () async {
      when(() => mockRepository.getTags()).thenAnswer(
        (_) async => const Success([Tag(name: 'urgent'), Tag(name: 'easy')]),
      );
      when(
        () => mockRepository.saveTags(any()),
      ).thenAnswer((_) async => const Success(null));
      await container.read(tagNotifierProvider.future);

      final result = await container
          .read(tagNotifierProvider.notifier)
          .remove(0);

      result.when(
        onSuccess: (value) => expect(value.map((t) => t.name), ['easy']),
        onFailure: (_) => fail('expected success'),
      );
    });
  });
}
