import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';

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
  final ActivityStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    this.notes,
    required this.disciplineId,
    required this.dueDate,
    required this.category,
    required this.tags,
    required this.reminders,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

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
      id: map['id'],
      title: map['title'],
      description: map['description'],
      notes: map['notes'],
      disciplineId: map['disciplineId'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      category: map['category'],
      tags: map['tags'] == null || (map['tags'] as String).isEmpty
          ? <String>[]
          : List<String>.from(jsonDecode(map['tags'] as String)),
      reminders:
          map['reminders'] == null || (map['reminders'] as String).isEmpty
          ? <TimeOfDay>[]
          : (jsonDecode(map['reminders'] as String) as List)
                .map(
                  (e) => TimeOfDay(
                    hour: e['hour'] as int,
                    minute: e['minute'] as int,
                  ),
                )
                .toList(),
      status: ActivityStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ActivityStatus.draft,
      ),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
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
        reminders.map((e) => {'hour': e.hour, 'minute': e.minute}).toList(),
      ),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
