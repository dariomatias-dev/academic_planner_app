import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/notes/domain/entities/note.dart';

abstract class NoteRepository {
  Future<Result<void>> add(Note note);

  Future<Result<List<Note>>> getAll();

  Future<Result<Note?>> getById(String id);

  Future<Result<void>> update(Note note);

  Future<Result<void>> delete(String id);
}
