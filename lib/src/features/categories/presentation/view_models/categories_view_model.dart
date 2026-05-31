import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/categories/data/models/category_model.dart';
import 'package:academic_planner/src/features/categories/domain/repositories/category_repository.dart';

class CategoriesViewModel {
  final CategoryRepository repository;

  CategoriesViewModel(this.repository);

  Future<Result<List<CategoryModel>>> load() async {
    return repository.getCategories();
  }

  Future<Result<List<CategoryModel>>> add(
    List<CategoryModel> current,
    String name,
  ) async {
    final exists = current.any(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      return const FailureResult(ValidationFailure('Categoria já existe'));
    }

    final updated = <CategoryModel>[...current, CategoryModel(name)];

    final result = await repository.saveCategories(updated);

    return result.fold(
      onSuccess: (_) => Success(updated),
      onFailure: (f) => FailureResult(f),
    );
  }

  Future<Result<List<CategoryModel>>> update(
    List<CategoryModel> current,
    int index,
    String name,
  ) async {
    final exists = current.asMap().entries.any(
      (entry) =>
          entry.key != index &&
          entry.value.name.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      return const FailureResult(ValidationFailure('Categoria já existe'));
    }

    final updated = <CategoryModel>[...current];
    updated[index] = CategoryModel(name);

    final result = await repository.saveCategories(updated);

    return result.fold(
      onSuccess: (_) => Success(updated),
      onFailure: (f) => FailureResult(f),
    );
  }

  Future<Result<List<CategoryModel>>> remove(
    List<CategoryModel> current,
    int index,
  ) async {
    final updated = <CategoryModel>[...current]..removeAt(index);

    final result = await repository.saveCategories(updated);

    return result.fold(
      onSuccess: (_) => Success(updated),
      onFailure: (f) => FailureResult(f),
    );
  }
}
