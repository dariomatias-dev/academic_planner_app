import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/domain/repositories/tag_repository.dart';
import 'package:academic_planner/src/features/tags/presentation/view_models/tag_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTagRepository extends Mock implements TagRepository {}

List<String> _names(List<Tag> tags) => tags.map((t) => t.name).toList();

void main() {
  late MockTagRepository mockRepository;
  late TagViewModel sut;

  setUpAll(() {
    registerFallbackValue(<Tag>[]);
  });

  setUp(() {
    mockRepository = MockTagRepository();
    sut = TagViewModel(mockRepository);
  });

  group('load', () {
    test('returns tags from repository', () async {
      final tags = [const Tag(name: 'Urgent')];
      when(
        () => mockRepository.getTags(),
      ).thenAnswer((_) async => Success<List<Tag>>(tags));

      final result = await sut.load();

      result.when(
        onSuccess: (value) => expect(value, tags),
        onFailure: (_) => fail('expected success'),
      );
    });

    test('propagates failure from repository', () async {
      when(() => mockRepository.getTags()).thenAnswer(
        (_) async => const Failure<List<Tag>>(DatabaseFailure('load failed')),
      );

      final result = await sut.load();

      expect(result, isA<Failure<List<Tag>>>());
    });
  });

  group('add', () {
    test('appends new tag and saves it', () async {
      const current = [Tag(name: 'Urgent')];
      when(
        () => mockRepository.saveTags(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.add(current, 'Important');

      result.when(
        onSuccess: (value) => expect(_names(value), ['Urgent', 'Important']),
        onFailure: (_) => fail('expected success'),
      );
      final captured =
          verify(() => mockRepository.saveTags(captureAny())).captured.single
              as List<Tag>;
      expect(_names(captured), ['Urgent', 'Important']);
    });

    test('rejects a duplicate name case-insensitively', () async {
      const current = [Tag(name: 'Urgent')];

      final result = await sut.add(current, 'urgent');

      expect(result, isA<Failure<List<Tag>>>());
      result.when(
        onSuccess: (_) => fail('expected failure'),
        onFailure: (f) => expect(f, isA<ValidationFailure>()),
      );
      verifyNever(() => mockRepository.saveTags(any()));
    });

    test('propagates failure from repository', () async {
      const current = <Tag>[];
      when(() => mockRepository.saveTags(any())).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('save failed')),
      );

      final result = await sut.add(current, 'Important');

      expect(result, isA<Failure<List<Tag>>>());
    });
  });

  group('update', () {
    test('renames the tag at the given index', () async {
      const current = [Tag(name: 'Urgent'), Tag(name: 'Important')];
      when(
        () => mockRepository.saveTags(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.update(current, 1, 'Critical');

      result.when(
        onSuccess: (value) => expect(_names(value), ['Urgent', 'Critical']),
        onFailure: (_) => fail('expected success'),
      );
    });

    test('rejects a name already used by another entry', () async {
      const current = [Tag(name: 'Urgent'), Tag(name: 'Important')];

      final result = await sut.update(current, 1, 'urgent');

      expect(result, isA<Failure<List<Tag>>>());
      verifyNever(() => mockRepository.saveTags(any()));
    });

    test('allows renaming to its own current name', () async {
      const current = [Tag(name: 'Urgent'), Tag(name: 'Important')];
      when(
        () => mockRepository.saveTags(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.update(current, 1, 'Important');

      expect(result, isA<Success<List<Tag>>>());
    });

    test('propagates failure from repository', () async {
      const current = [Tag(name: 'Urgent')];
      when(() => mockRepository.saveTags(any())).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('save failed')),
      );

      final result = await sut.update(current, 0, 'Renamed');

      expect(result, isA<Failure<List<Tag>>>());
    });
  });

  group('remove', () {
    test(
      'removes the tag at the given index and saves the rest',
      () async {
        const current = [Tag(name: 'Urgent'), Tag(name: 'Important')];
        when(
          () => mockRepository.saveTags(any()),
        ).thenAnswer((_) async => const Success<void>(null));

        final result = await sut.remove(current, 0);

        result.when(
          onSuccess: (value) => expect(_names(value), ['Important']),
          onFailure: (_) => fail('expected success'),
        );
      },
    );

    test('propagates failure from repository', () async {
      const current = [Tag(name: 'Urgent')];
      when(() => mockRepository.saveTags(any())).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('save failed')),
      );

      final result = await sut.remove(current, 0);

      expect(result, isA<Failure<List<Tag>>>());
    });
  });
}
