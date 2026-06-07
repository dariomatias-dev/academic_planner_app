import 'package:academic_planner/src/features/notes/domain/entities/note.dart';

class NoteModel {
  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.disciplineId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      disciplineId: note.disciplineId,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    );
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      disciplineId: map['disciplineId'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  final String id;
  final String title;
  final String content;
  final int disciplineId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note toEntity() {
    return Note(
      id: id,
      title: title,
      content: content,
      disciplineId: disciplineId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'disciplineId': disciplineId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
