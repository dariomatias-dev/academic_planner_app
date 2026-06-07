import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/presentation/view_models/note_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class NoteNotifier extends AsyncNotifier<void> {
  static final _log = Logger('notes.NoteNotifier');

  late final NoteViewModel _viewModel;

  @override
  Future<void> build() async {
    final repository = ref.read(noteRepositoryProvider);

    _viewModel = NoteViewModel(repository);
  }

  Future<Result<void>> add(Note note) async {
    state = const AsyncLoading();

    final result = await _viewModel.create(note);

    result.fold(
      onSuccess: (_) {},
      onFailure: (f) => _log.warning('add failed: ${f.message}'),
    );

    state = const AsyncData(null);

    return result;
  }

  Future<Result<List<Note>>> getAll() {
    return _viewModel.getAll();
  }

  Future<Result<Note?>> getById(String id) {
    return _viewModel.getById(id);
  }

  Future<Result<void>> edit(Note note) async {
    state = const AsyncLoading();

    final result = await _viewModel.update(note);

    result.fold(
      onSuccess: (_) {},
      onFailure: (f) => _log.warning('edit failed: ${f.message}'),
    );

    state = const AsyncData(null);

    return result;
  }

  Future<Result<void>> delete(String id) async {
    state = const AsyncLoading();

    final result = await _viewModel.delete(id);

    result.fold(
      onSuccess: (_) {},
      onFailure: (f) => _log.warning('delete failed: ${f.message}'),
    );

    state = const AsyncData(null);

    return result;
  }

  Note createNew({
    required String title,
    required String content,
    required int disciplineId,
  }) {
    return _viewModel.createNew(
      title: title,
      content: content,
      disciplineId: disciplineId,
    );
  }
}
