import 'package:academic_planner/src/features/categories/data/models/category_model.dart';
import 'package:academic_planner/src/features/categories/domain/repositories/category_repository.dart';

class CategoriesViewModel {
  final CategoryRepository repository;

  CategoriesViewModel(this.repository);

  Future<List<CategoryModel>> load() {
    return repository.getCategories();
  }

  Future<List<CategoryModel>> add(
    List<CategoryModel> current,
    String name,
  ) async {
    final updated = <CategoryModel>[...current, CategoryModel(name)];

    await repository.saveCategories(updated);

    return updated;
  }

  Future<List<CategoryModel>> update(
    List<CategoryModel> current,
    int index,
    String name,
  ) async {
    final updated = <CategoryModel>[...current];
    updated[index] = CategoryModel(name);

    await repository.saveCategories(updated);

    return updated;
  }

  Future<List<CategoryModel>> remove(
    List<CategoryModel> current,
    int index,
  ) async {
    final updated = <CategoryModel>[...current]..removeAt(index);

    await repository.saveCategories(updated);

    return updated;
  }
}
