import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/presentation/view_models/tag_view_model.dart';

class TagNotifier extends AsyncNotifier<List<Tag>> {
  late final TagViewModel viewModel;

  @override
  Future<List<Tag>> build() async {
    final repo = ref.read(tagRepositoryProvider);

    viewModel = TagViewModel(repo);

    final result = await viewModel.load();

    return result.fold(
      onSuccess: (data) => data,
      onFailure: (_) => <Tag>[],
    );
  }

  Future<Result<List<Tag>>> add(String name) async {
    final current = state.asData?.value ?? [];
    final result = await viewModel.add(current, name);

    result.when(onSuccess: (data) => state = AsyncData(data));

    return result;
  }

  Future<Result<List<Tag>>> edit(int index, String name) async {
    final current = state.asData?.value ?? [];
    final result = await viewModel.update(current, index, name);

    result.when(onSuccess: (data) => state = AsyncData(data));

    return result;
  }

  Future<Result<List<Tag>>> remove(int index) async {
    final current = state.asData?.value ?? [];
    final result = await viewModel.remove(current, index);

    result.when(onSuccess: (data) => state = AsyncData(data));

    return result;
  }
}
