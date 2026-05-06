import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/categories/data/models/category_model.dart';
import 'package:academic_planner/src/features/categories/domain/repositories/category_repository.dart';

class CategoriesViewModel {
  final CategoryRepository repository;

  CategoriesViewModel(this.repository);

  Future<Result<List<CategoryModel>>> load() async {
    final data = await repository.getCategories();
    return Success(data);
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

    await repository.saveCategories(updated);

    return Success(updated);
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

    await repository.saveCategories(updated);

    return Success(updated);
  }

  Future<Result<List<CategoryModel>>> remove(
    List<CategoryModel> current,
    int index,
  ) async {
    final updated = <CategoryModel>[...current]..removeAt(index);

    await repository.saveCategories(updated);

    return Success(updated);
  }
}
