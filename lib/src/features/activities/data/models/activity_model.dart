import 'dart:convert';

import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:flutter/material.dart';

class ActivityModel {
  ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.disciplineId,
    required this.dueDate,
    required this.category,
    required this.tags,
    required this.reminders,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  factory ActivityModel.fromEntity(Activity activity) {
    return ActivityModel(
      id: activity.id,
      title: activity.title,
      description: activity.description,
      notes: activity.notes,
      disciplineId: activity.disciplineId,
      dueDate: activity.dueDate,
      category: activity.category,
      tags: activity.tags,
      reminders: activity.reminders,
      status: activity.status,
      createdAt: activity.createdAt,
      updatedAt: activity.updatedAt,
    );
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      notes: map['notes'] as String?,
      disciplineId: map['disciplineId'] as int,
      dueDate: map['dueDate'] != null
          ? DateTime.parse(map['dueDate'] as String)
          : null,
      category: map['category'] as String?,
      tags: map['tags'] == null || (map['tags'] as String).isEmpty
          ? []
          : List<String>.from(
              jsonDecode(map['tags'] as String) as List<dynamic>,
            ),
      reminders:
          map['reminders'] == null || (map['reminders'] as String).isEmpty
          ? []
          : (jsonDecode(map['reminders'] as String) as List<dynamic>).builder(
              (e, index) => TimeOfDay(
                hour: (e as Map<String, dynamic>)['hour'] as int,
                minute: e['minute'] as int,
              ),
            ),
      status: ActivityStatus.values.firstWhere(
        (e) => e.name == map['status'] as String,
        orElse: () => ActivityStatus.draft,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  final String id;
  final String title;
  final String description;
  final String? notes;
  final int disciplineId;
  final DateTime? dueDate;
  final String? category;
  final List<String> tags;
  final List<TimeOfDay> reminders;
  final ActivityStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Activity toEntity() {
    return Activity(
      id: id,
      title: title,
      description: description,
      notes: notes,
      disciplineId: disciplineId,
      dueDate: dueDate,
      category: category,
      tags: tags,
      reminders: reminders,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'notes': notes,
      'disciplineId': disciplineId,
      'dueDate': dueDate?.toIso8601String(),
      'category': category,
      'tags': jsonEncode(tags),
      'reminders': jsonEncode(
        reminders.builder((e, index) => {'hour': e.hour, 'minute': e.minute}),
      ),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
