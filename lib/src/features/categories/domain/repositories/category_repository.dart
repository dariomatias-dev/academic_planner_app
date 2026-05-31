import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/categories/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<Result<List<Category>>> getCategories();

  Future<Result<void>> saveCategories(List<Category> categories);
}
