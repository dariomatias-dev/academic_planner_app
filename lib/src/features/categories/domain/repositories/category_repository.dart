import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/categories/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<Result<List<CategoryModel>>> getCategories();

  Future<Result<void>> saveCategories(List<CategoryModel> categories);
}
