import 'package:academic_planner/src/features/categories/domain/entities/category.dart';

class CategoryModel {
  const CategoryModel(this.name);

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(category.name);
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(map['name'] as String);
  }

  final String name;

  Category toEntity() => Category(name: name);

  Map<String, dynamic> toMap() {
    return {'name': name};
  }
}
