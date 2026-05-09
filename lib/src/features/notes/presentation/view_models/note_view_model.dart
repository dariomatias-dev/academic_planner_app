import 'package:uuid/uuid.dart';

import 'package:academic_planner/src/core/logging/logger_service.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/domain/repositories/note_repository.dart';

class NoteViewModel {
  final NoteRepository repository;
  final LoggerService _logger;

  NoteViewModel(this.repository, this._logger);

  Future<Result<void>> create(Note note) async {
    _logger.info('createNote started: ${note.title}');

    return await repository.add(note);
  }

  Future<Result<List<Note>>> getAll() async {
    return await repository.getAll();
  }

  Future<Result<Note?>> getById(String id) async {
    return await repository.getById(id);
  }

  Future<Result<void>> update(Note note) async {
    final updated = note.copyWith(updatedAt: DateTime.now());
    return await repository.update(updated);
  }

  Future<Result<void>> delete(String id) async {
    return await repository.delete(id);
  }

  Note createNew({
    required String title,
    required String content,
    required int disciplineId,
  }) {
    final now = DateTime.now();
    return Note(
      id: const Uuid().v7(),
      title: title,
      content: content,
      disciplineId: disciplineId,
      createdAt: now,
      updatedAt: now,
    );
  }
}
