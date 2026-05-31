import 'package:academic_planner/src/features/categories/domain/entities/category.dart';

class CategoryModel {
  final String name;

  const CategoryModel(this.name);

  Category toEntity() => Category(name: name);

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(category.name);
  }

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(map['name'] as String);
  }
}
