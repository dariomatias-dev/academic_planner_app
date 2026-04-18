import 'package:flutter/material.dart';

enum ActivityStatus { draft, pending, inProgress, completed, canceled }

class Activity {
  final String id;
  final String title;
  final String description;
  final String? notes;
  final int disciplineId;
  final String? category;
  final DateTime? dueDate;
  final List<String> tags;
  final List<TimeOfDay> reminders;
  final ActivityStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    this.notes,
    required this.disciplineId,
    this.category,
    this.dueDate,
    required this.tags,
    required this.reminders,
    required this.status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Activity copyWith({
    String? id,
    String? title,
    String? description,
    String? notes,
    int? disciplineId,
    String? category,
    DateTime? dueDate,
    List<String>? tags,
    List<TimeOfDay>? reminders,
    ActivityStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      disciplineId: disciplineId ?? this.disciplineId,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      tags: tags ?? this.tags,
      reminders: reminders ?? this.reminders,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
