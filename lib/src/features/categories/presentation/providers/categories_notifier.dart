import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:academic_planner/src/features/categories/presentation/view_models/category_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesNotifier extends AsyncNotifier<List<Category>> {
  late final CategoryViewModel _viewModel;

  @override
  Future<List<Category>> build() async {
    final repo = ref.read(categoryRepositoryProvider);

    _viewModel = CategoryViewModel(repo);

    final result = await _viewModel.load();

    return result.fold(
      onSuccess: (data) => data,
      onFailure: (_) => [],
    );
  }

  Future<List<Category>> _currentCategories() async {
    if (state case AsyncData(:final value)) return value;

    final result = await _viewModel.load();

    return result.fold(onSuccess: (data) => data, onFailure: (_) => []);
  }

  Future<Result<List<Category>>> add(String name) async {
    final current = await _currentCategories();
    final result = await _viewModel.add(current, name);

    if (result case Success(:final value)) state = AsyncData(value);

    return result;
  }

  Future<Result<List<Category>>> edit(int index, String name) async {
    final current = await _currentCategories();
    final result = await _viewModel.update(current, index, name);

    if (result case Success(:final value)) state = AsyncData(value);

    return result;
  }

  Future<Result<List<Category>>> remove(int index) async {
    final current = await _currentCategories();
    final result = await _viewModel.remove(current, index);

    if (result case Success(:final value)) state = AsyncData(value);

    return result;
  }
}
