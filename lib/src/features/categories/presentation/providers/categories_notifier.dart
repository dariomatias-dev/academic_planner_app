import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/categories/data/models/category_model.dart';
import 'package:academic_planner/src/features/categories/di/categories_provider.sdart';
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
    state = await viewModel.load();
  }

  Future<void> add(String name) async {
    state = await viewModel.add(state, name);
  }

  Future<void> update(int index, String name) async {
    state = await viewModel.update(state, index, name);
  }

  Future<void> remove(int index) async {
    state = await viewModel.remove(state, index);
  }
}
