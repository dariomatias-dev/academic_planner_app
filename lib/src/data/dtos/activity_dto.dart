import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';

class ActivityDto {
  final String id;
  final String title;
  final String description;
  final String? notes;
  final int disciplineId;
  final String? dueDate;
  final String? category;
  final String tags;
  final String reminders;
  final String? status;
  final String createdAt;
  final String updatedAt;

  ActivityDto({
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActivityDto.fromEntity(ActivityModel activity) {
    return ActivityDto(
      id: activity.id,
      title: activity.title,
      description: activity.description,
      notes: activity.notes,
      disciplineId: activity.disciplineId,
      dueDate: activity.dueDate?.toIso8601String(),
      category: activity.category,
      tags: activity.tags.join(','),
      reminders: activity.reminders
          .map((t) => '${t.hour}:${t.minute}')
          .join(','),
      status: activity.status?.name,
      createdAt: activity.createdAt.toIso8601String(),
      updatedAt: activity.updatedAt.toIso8601String(),
    );
  }

  ActivityModel toEntity() {
    return ActivityModel(
      id: id,
      title: title,
      description: description,
      notes: notes,
      disciplineId: disciplineId,
      dueDate: dueDate != null ? DateTime.parse(dueDate!) : null,
      category: category,
      tags: tags.isNotEmpty ? tags.split(',') : [],
      reminders: reminders.isNotEmpty
          ? reminders.split(',').builder((s, index) {
              final parts = s.split(':');

              return TimeOfDay(
                hour: int.parse(parts[0]),
                minute: int.parse(parts[1]),
              );
            })
          : <TimeOfDay>[],
      status: status != null
          ? ActivityStatus.values.firstWhere((e) => e.name == status)
          : null,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  factory ActivityDto.fromMap(Map<String, dynamic> map) {
    return ActivityDto(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      notes: map['notes'],
      disciplineId: map['disciplineId'],
      dueDate: map['dueDate'],
      category: map['category'],
      tags: map['tags'] ?? '',
      reminders: map['reminders'] ?? '',
      status: map['status'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'notes': notes,
      'disciplineId': disciplineId,
      'dueDate': dueDate,
      'category': category,
      'tags': tags,
      'reminders': reminders,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
