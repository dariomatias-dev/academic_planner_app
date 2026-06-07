import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:academic_planner/src/features/categories/domain/repositories/category_repository.dart';

class CategoriesViewModel {
  CategoriesViewModel(this.repository);

  final CategoryRepository repository;

  Future<Result<List<Category>>> load() async {
    return repository.getCategories();
  }

  Future<Result<List<Category>>> add(
    List<Category> current,
    String name,
  ) async {
    final exists = current.any(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      return const Failure(ValidationFailure('Categoria já existe'));
    }

    final updated = <Category>[...current, Category(name: name)];

    final result = await repository.saveCategories(updated);

    return result.fold(
      onSuccess: (_) => Success(updated),
      onFailure: Failure.new,
    );
  }

  Future<Result<List<Category>>> update(
    List<Category> current,
    int index,
    String name,
  ) async {
    final exists = current.asMap().entries.any(
      (entry) =>
          entry.key != index &&
          entry.value.name.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      return const Failure(ValidationFailure('Categoria já existe'));
    }

    final updated = <Category>[...current];
    updated[index] = Category(name: name);

    final result = await repository.saveCategories(updated);

    return result.fold(
      onSuccess: (_) => Success(updated),
      onFailure: Failure.new,
    );
  }

  Future<Result<List<Category>>> remove(
    List<Category> current,
    int index,
  ) async {
    final updated = <Category>[...current]..removeAt(index);

    final result = await repository.saveCategories(updated);

    return result.fold(
      onSuccess: (_) => Success(updated),
      onFailure: Failure.new,
    );
  }
}
