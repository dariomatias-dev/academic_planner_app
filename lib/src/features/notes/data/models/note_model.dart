import 'package:academic_planner/src/features/notes/domain/entities/note.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final int disciplineId;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.disciplineId,
    required this.createdAt,
    required this.updatedAt,
  });

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
      id: map['id'],
      title: map['title'],
      content: map['content'],
      disciplineId: map['disciplineId'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
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
