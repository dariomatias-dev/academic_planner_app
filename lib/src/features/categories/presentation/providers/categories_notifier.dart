import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:academic_planner/src/features/categories/presentation/view_models/categories_view_model.dart';

class CategoriesNotifier extends AsyncNotifier<List<Category>> {
  late final CategoriesViewModel viewModel;

  @override
  Future<List<Category>> build() async {
    final repo = ref.read(categoryRepositoryProvider);

    viewModel = CategoriesViewModel(repo);

    final result = await viewModel.load();

    return result.fold(
      onSuccess: (data) => data,
      onFailure: (_) => <Category>[],
    );
  }

  Future<Result<List<Category>>> add(String name) async {
    final current = state.asData?.value ?? [];
    final result = await viewModel.add(current, name);

    result.when(onSuccess: (data) => state = AsyncData(data));

    return result;
  }

  Future<Result<List<Category>>> edit(int index, String name) async {
    final current = state.asData?.value ?? [];
    final result = await viewModel.update(current, index, name);

    result.when(onSuccess: (data) => state = AsyncData(data));

    return result;
  }

  Future<Result<List<Category>>> remove(int index) async {
    final current = state.asData?.value ?? [];
    final result = await viewModel.remove(current, index);

    result.when(onSuccess: (data) => state = AsyncData(data));

    return result;
  }
}
