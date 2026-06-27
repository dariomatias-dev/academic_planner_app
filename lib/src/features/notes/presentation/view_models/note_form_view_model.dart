import 'dart:convert';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/domain/entities/discipline.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/presentation/providers/note_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:logging/logging.dart';

class NoteFormViewModel {
  NoteFormViewModel(this._noteNotifier) {
    titleController.addListener(updateChangeTracker);
    contentController.addListener(updateChangeTracker);
  }

  static final _log = Logger('notes.NoteFormViewModel');

  final NoteNotifier _noteNotifier;

  final titleController = TextEditingController();
  final contentController = QuillController.basic();

  final _disciplineNotifier = ValueNotifier<Discipline?>(null);
  final _isLoadingNotifier = ValueNotifier<bool>(false);
  final _canSaveNotifier = ValueNotifier<bool>(false);

  ValueListenable<Discipline?> get discipline => _disciplineNotifier;
  ValueListenable<bool> get isLoading => _isLoadingNotifier;
  ValueListenable<bool> get canSave => _canSaveNotifier;

  Note? _initialNote;

  Future<Result<void>> load({
    required String? noteId,
    required int disciplineId,
  }) async {
    if (noteId == null) {
      _initNew(disciplineId);

      return const Success(null);
    }

    _isLoadingNotifier.value = true;

    final result = await _noteNotifier.getById(noteId);

    _isLoadingNotifier.value = false;

    return result.fold(
      onSuccess: (note) {
        if (note != null) _loadFromNote(note);

        return const Success(null);
      },
      onFailure: Failure.new,
    );
  }

  Future<Result<void>> save() async {
    if (_initialNote != null) {
      return _noteNotifier.edit(_buildUpdatedNote());
    }

    final newNote = _noteNotifier.createNew(
      title: titleController.text.trim(),
      content: _getEncodedContent(),
      disciplineId: _disciplineNotifier.value!.id,
    );

    return _noteNotifier.add(newNote);
  }

  void setDiscipline(Discipline value) {
    _disciplineNotifier.value = value;

    updateChangeTracker();
  }

  void updateChangeTracker() {
    _canSaveNotifier.value = hasChanges();
  }

  bool hasChanges() {
    if (_initialNote == null) return true;

    final currentContent = _getEncodedContent();

    return titleController.text.trim() != _initialNote!.title.trim() ||
        currentContent != _initialNote!.content ||
        _disciplineNotifier.value?.id != _initialNote!.disciplineId;
  }

  void _initNew(int disciplineId) {
    _disciplineNotifier.value = adsDisciplines.where((d) {
      return d.id == disciplineId;
    }).firstOrNull;

    updateChangeTracker();
  }

  void _loadFromNote(Note note) {
    _initialNote = note;
    titleController.text = note.title;

    try {
      final doc = Document.fromJson(
        jsonDecode(note.content) as List<dynamic>,
      );

      contentController.document = doc;
      contentController.updateSelection(
        const TextSelection.collapsed(offset: 0),
        ChangeSource.local,
      );
    } on Exception catch (err, stackTrace) {
      _log.severe('Failed to parse content', err, stackTrace);
    }

    _disciplineNotifier.value = adsDisciplines.where((d) {
      return d.id == note.disciplineId;
    }).firstOrNull;

    updateChangeTracker();
  }

  Note _buildUpdatedNote() {
    return _initialNote!.copyWith(
      title: titleController.text.trim(),
      content: _getEncodedContent(),
      disciplineId: _disciplineNotifier.value?.id,
    );
  }

  String _getEncodedContent() {
    return jsonEncode(contentController.document.toDelta().toJson());
  }

  void dispose() {
    titleController.dispose();
    contentController.dispose();
    _disciplineNotifier.dispose();
    _isLoadingNotifier.dispose();
    _canSaveNotifier.dispose();
  }
}
