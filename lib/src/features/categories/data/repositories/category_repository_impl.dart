import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/result/exception_mapper.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/categories/data/data_source/category_local_datasource.dart';
import 'package:academic_planner/src/features/categories/data/models/category_model.dart';
import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:academic_planner/src/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource datasource;

  static const _defaultCategories = <Category>[
    Category(name: 'Estudo'),
    Category(name: 'Leitura'),
    Category(name: 'Projeto'),
    Category(name: 'Prova'),
    Category(name: 'Trabalho'),
  ];

  CategoryRepositoryImpl(this.datasource);

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      final data = datasource.getAll();

      if (data.isEmpty) return const Success(_defaultCategories);

      return Success(
        data.builder((e, index) => CategoryModel.fromMap(e).toEntity()),
      );
    } catch (err) {
      return FailureResult(ExceptionMapper.mapDatabase(err));
    }
  }

  @override
  Future<Result<void>> saveCategories(List<Category> categories) async {
    try {
      await datasource.saveAll(
        categories.builder((e, index) => CategoryModel.fromEntity(e).toMap()),
      );

      return const Success(null);
    } catch (err) {
      return FailureResult(ExceptionMapper.mapDatabase(err));
    }
  }
}
