import 'package:flutter/material.dart';

enum ActivityStatus { draft, pending, inProgress, completed, canceled }

class ActivityModel {
  final String id;
  final String title;
  final String description;
  final String? notes;
  final int disciplineId;
  final DateTime? dueDate;
  final String? category;
  final List<String> tags;
  final List<TimeOfDay> reminders;
  final ActivityStatus? status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    this.notes,
    required this.disciplineId,
    this.dueDate,
    this.category,
    required this.tags,
    required this.reminders,
    this.status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  ActivityModel copyWith({
    String? id,
    String? title,
    String? description,
    String? notes,
    int? disciplineId,
    DateTime? dueDate,
    String? category,
    List<String>? tags,
    List<TimeOfDay>? reminders,
    ActivityStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      disciplineId: disciplineId ?? this.disciplineId,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      reminders: reminders ?? this.reminders,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
