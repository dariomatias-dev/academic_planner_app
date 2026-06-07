import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/domain/repositories/note_repository.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

class NoteViewModel {
  NoteViewModel(this.repository);

  static final _log = Logger('notes.NoteViewModel');

  final NoteRepository repository;

  Future<Result<void>> create(Note note) async {
    _log.info('createNote started: ${note.title}');

    return repository.add(note);
  }

  Future<Result<List<Note>>> getAll() async {
    return repository.getAll();
  }

  Future<Result<Note?>> getById(String id) async {
    return repository.getById(id);
  }

  Future<Result<void>> update(Note note) async {
    final updated = note.copyWith(updatedAt: DateTime.now());

    return repository.update(updated);
  }

  Future<Result<void>> delete(String id) async {
    return repository.delete(id);
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
