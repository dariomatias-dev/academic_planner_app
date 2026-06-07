import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/presentation/view_models/tag_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagNotifier extends AsyncNotifier<List<Tag>> {
  late final TagViewModel _viewModel;

  @override
  Future<List<Tag>> build() async {
    final repo = ref.read(tagRepositoryProvider);

    _viewModel = TagViewModel(repo);

    final result = await _viewModel.load();

    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw Exception(f.message),
    );
  }

  Future<List<Tag>> _currentTags() async {
    if (state case AsyncData(:final value)) return value;

    final result = await _viewModel.load();

    return result.fold(onSuccess: (data) => data, onFailure: (_) => []);
  }

  Future<Result<List<Tag>>> add(String name) async {
    final current = await _currentTags();
    final result = await _viewModel.add(current, name);

    if (result case Success(:final value)) state = AsyncData(value);

    return result;
  }

  Future<Result<List<Tag>>> edit(int index, String name) async {
    final current = await _currentTags();
    final result = await _viewModel.update(current, index, name);

    if (result case Success(:final value)) state = AsyncData(value);

    return result;
  }

  Future<Result<List<Tag>>> remove(int index) async {
    final current = await _currentTags();
    final result = await _viewModel.remove(current, index);

    if (result case Success(:final value)) state = AsyncData(value);

    return result;
  }
}
