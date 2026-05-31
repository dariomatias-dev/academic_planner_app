import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/tags/data/models/tag_model.dart';
import 'package:academic_planner/src/features/tags/domain/repositories/tag_repository.dart';

class TagViewModel {
  final TagRepository repository;

  TagViewModel(this.repository);

  Future<Result<List<TagModel>>> load() async {
    return repository.getTags();
  }

  Future<Result<List<TagModel>>> add(
    List<TagModel> current,
    String name,
  ) async {
    final exists = current.any(
      (t) => t.name.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      return const FailureResult(ValidationFailure('Tag já existe'));
    }

    final updated = <TagModel>[...current, TagModel(name)];

    final result = await repository.saveTags(updated);

    return result.fold(
      onSuccess: (_) => Success(updated),
      onFailure: (f) => FailureResult(f),
    );
  }

  Future<Result<List<TagModel>>> update(
    List<TagModel> current,
    int index,
    String name,
  ) async {
    final exists = current.asMap().entries.any(
      (entry) =>
          entry.key != index &&
          entry.value.name.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      return const FailureResult(ValidationFailure('Tag já existe'));
    }

    final updated = <TagModel>[...current];
    updated[index] = TagModel(name);

    final result = await repository.saveTags(updated);

    return result.fold(
      onSuccess: (_) => Success(updated),
      onFailure: (f) => FailureResult(f),
    );
  }

  Future<Result<List<TagModel>>> remove(
    List<TagModel> current,
    int index,
  ) async {
    final updated = <TagModel>[...current]..removeAt(index);

    final result = await repository.saveTags(updated);

    return result.fold(
      onSuccess: (_) => Success(updated),
      onFailure: (f) => FailureResult(f),
    );
  }
}
