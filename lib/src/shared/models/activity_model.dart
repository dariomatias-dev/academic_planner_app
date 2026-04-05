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

  const ActivityModel({
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
  });
}
