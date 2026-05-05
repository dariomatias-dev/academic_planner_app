import 'dart:convert';

import 'package:academic_planner/src/core/services/shared_preferences_service.dart';

import 'package:academic_planner/src/features/categories/data/models/category_model.dart';
import 'package:academic_planner/src/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final SharedPreferencesService prefs;

  static const _key = 'categories';

  CategoryRepositoryImpl(this.prefs);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final jsonString = prefs.getString(_key);

    if (jsonString.isEmpty) {
      return _defaultCategories();
    }

    final List decoded = jsonDecode(jsonString);

    return decoded.map((e) => CategoryModel.fromMap(e)).toList();
  }

  @override
  Future<void> saveCategories(List<CategoryModel> categories) async {
    final encoded = jsonEncode(categories.map((e) => e.toMap()).toList());

    await prefs.setString(_key, encoded);
  }

  List<CategoryModel> _defaultCategories() {
    return const <CategoryModel>[
      CategoryModel("Estudo"),
      CategoryModel("Leitura"),
      CategoryModel("Projeto"),
      CategoryModel("Prova"),
      CategoryModel("Trabalho"),
    ];
  }
}
