import 'package:flutter/foundation.dart';

import 'package:academic_planner/src/core/result/exception_mapper.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/notes/data/data_source/note_local_datasource.dart';
import 'package:academic_planner/src/features/notes/data/models/note_model.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/domain/repositories/note_repository.dart';

List<Note> _mapNotes(List<Map<String, dynamic>> data) {
  return data.map((e) => NoteModel.fromMap(e).toEntity()).toList();
}

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource datasource;

  NoteRepositoryImpl(this.datasource);

  @override
  Future<Result<void>> add(Note note) async {
    try {
      await datasource.insert(NoteModel.fromEntity(note).toMap());

      return const Success(null);
    } catch (err) {
      return FailureResult(ExceptionMapper.mapDatabase(err));
    }
  }

  @override
  Future<Result<List<Note>>> getAll() async {
    try {
      final data = await datasource.getAll();
      final notes = await compute(_mapNotes, data);

      return Success(notes);
    } catch (err) {
      return FailureResult(ExceptionMapper.mapDatabase(err));
    }
  }

  @override
  Future<Result<Note?>> getById(String id) async {
    try {
      final data = await datasource.getById(id);

      if (data == null) return const Success(null);

      return Success(NoteModel.fromMap(data).toEntity());
    } catch (err) {
      return FailureResult(ExceptionMapper.mapDatabase(err));
    }
  }

  @override
  Future<Result<void>> update(Note note) async {
    try {
      await datasource.update(note.id, NoteModel.fromEntity(note).toMap());

      return const Success(null);
    } catch (err) {
      return FailureResult(ExceptionMapper.mapDatabase(err));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await datasource.delete(id);
      
      return const Success(null);
    } catch (err) {
      return FailureResult(ExceptionMapper.mapDatabase(err));
    }
  }
}
