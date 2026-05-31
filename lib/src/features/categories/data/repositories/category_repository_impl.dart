import 'dart:convert';

import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/core/services/shared_preferences_service.dart';

import 'package:academic_planner/src/features/categories/data/models/category_model.dart';
import 'package:academic_planner/src/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final SharedPreferencesService prefs;

  static const _key = 'categories';

  CategoryRepositoryImpl(this.prefs);

  @override
  Future<Result<List<CategoryModel>>> getCategories() async {
    try {
      final jsonString = prefs.getString(_key);

      if (jsonString.isEmpty) {
        return Success(_defaultCategories());
      }

      final List decoded = jsonDecode(jsonString);

      return Success(decoded.map((e) => CategoryModel.fromMap(e)).toList());
    } catch (err) {
      return FailureResult(UnknownFailure(err.toString()));
    }
  }

  @override
  Future<Result<void>> saveCategories(List<CategoryModel> categories) async {
    try {
      final encoded = jsonEncode(categories.map((e) => e.toMap()).toList());

      await prefs.setString(_key, encoded);

      return const Success(null);
    } catch (err) {
      return FailureResult(UnknownFailure(err.toString()));
    }
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
