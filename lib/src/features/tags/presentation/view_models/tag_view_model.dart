import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/domain/repositories/tag_repository.dart';

class TagViewModel {
  final TagRepository repository;

  TagViewModel(this.repository);

  Future<Result<List<Tag>>> load() async {
    return repository.getTags();
  }

  Future<Result<List<Tag>>> add(
    List<Tag> current,
    String name,
  ) async {
    final exists = current.any(
      (t) => t.name.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      return const Failure(ValidationFailure('Tag já existe'));
    }

    final updated = <Tag>[...current, Tag(name: name)];

    final result = await repository.saveTags(updated);

    return result.fold(
      onSuccess: (_) => Success(updated),
      onFailure: (f) => Failure(f),
    );
  }

  Future<Result<List<Tag>>> update(
    List<Tag> current,
    int index,
    String name,
  ) async {
    final exists = current.asMap().entries.any(
      (entry) =>
          entry.key != index &&
          entry.value.name.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      return const Failure(ValidationFailure('Tag já existe'));
    }

    final updated = <Tag>[...current];
    updated[index] = Tag(name: name);

    final result = await repository.saveTags(updated);

    return result.fold(
      onSuccess: (_) => Success(updated),
      onFailure: (f) => Failure(f),
    );
  }

  Future<Result<List<Tag>>> remove(
    List<Tag> current,
    int index,
  ) async {
    final updated = <Tag>[...current]..removeAt(index);

    final result = await repository.saveTags(updated);

    return result.fold(
      onSuccess: (_) => Success(updated),
      onFailure: (f) => Failure(f),
    );
  }
}
