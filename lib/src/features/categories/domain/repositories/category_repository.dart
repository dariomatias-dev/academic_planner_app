import 'package:academic_planner/src/features/categories/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategories();

  Future<void> saveCategories(List<CategoryModel> categories);
}
