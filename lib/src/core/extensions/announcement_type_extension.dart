import 'package:flutter/material.dart';

import 'package:academic_planner/src/features/disciplines/domain/entities/announcement.dart';

extension AnnouncementTypeExtension on AnnouncementType {
  Color color(ColorScheme colorScheme) {
    return switch (this) {
      AnnouncementType.info => colorScheme.primary,
      AnnouncementType.reminder => colorScheme.secondary,
      AnnouncementType.poll => Colors.teal,
      AnnouncementType.alert => colorScheme.error,
    };
  }

  IconData get icon {
    return switch (this) {
      AnnouncementType.info => Icons.info_outline_rounded,
      AnnouncementType.reminder => Icons.event_note_rounded,
      AnnouncementType.poll => Icons.how_to_vote_rounded,
      AnnouncementType.alert => Icons.priority_high_rounded,
    };
  }

  String get label {
    return switch (this) {
      AnnouncementType.info => "INFORMATIVO",
      AnnouncementType.reminder => "LEMBRETE",
      AnnouncementType.poll => "ENQUETE",
      AnnouncementType.alert => "ALERTA",
    };
  }
}
