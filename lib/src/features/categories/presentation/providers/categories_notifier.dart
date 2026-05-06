import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/categories/data/models/category_model.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/features/categories/presentation/view_models/categories_view_model.dart';

class CategoriesNotifier extends Notifier<List<CategoryModel>> {
  late final CategoriesViewModel viewModel;

  @override
  List<CategoryModel> build() {
    final repo = ref.read(categoryRepositoryProvider);

    viewModel = CategoriesViewModel(repo);

    _load();

    return <CategoryModel>[];
  }

  Future<void> _load() async {
    final result = await viewModel.load();

    state = result.fold(
      onSuccess: (data) => data,
      onFailure: (_) => <CategoryModel>[],
    );
  }

  Future<Result<List<CategoryModel>>> add(String name) async {
    final result = await viewModel.add(state, name);

    result.when(onSuccess: (data) => state = data);

    return result;
  }

  Future<Result<List<CategoryModel>>> update(int index, String name) async {
    final result = await viewModel.update(state, index, name);

    result.when(onSuccess: (data) => state = data);

    return result;
  }

  Future<Result<List<CategoryModel>>> remove(int index) async {
    final result = await viewModel.remove(state, index);

    result.when(onSuccess: (data) => state = data);

    return result;
  }
}
