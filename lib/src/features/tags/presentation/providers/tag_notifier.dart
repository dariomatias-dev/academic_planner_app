import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/tags/data/models/tag_model.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/tags/presentation/view_models/tag_view_model.dart';

class TagNotifier extends Notifier<List<TagModel>> {
  late final TagViewModel viewModel;

  @override
  List<TagModel> build() {
    final repo = ref.read(tagRepositoryProvider);

    viewModel = TagViewModel(repo);

    _load();

    return <TagModel>[];
  }

  Future<void> _load() async {
    final result = await viewModel.load();

    state = result.fold(
      onSuccess: (data) => data,
      onFailure: (_) => <TagModel>[],
    );
  }

  Future<Result<List<TagModel>>> add(String name) async {
    final result = await viewModel.add(state, name);

    result.when(onSuccess: (data) => state = data);

    return result;
  }

  Future<Result<List<TagModel>>> update(int index, String name) async {
    final result = await viewModel.update(state, index, name);

    result.when(onSuccess: (data) => state = data);

    return result;
  }

  Future<Result<List<TagModel>>> remove(int index) async {
    final result = await viewModel.remove(state, index);

    result.when(onSuccess: (data) => state = data);

    return result;
  }
}
