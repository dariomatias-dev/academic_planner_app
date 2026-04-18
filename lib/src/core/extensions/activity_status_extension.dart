import 'package:flutter/material.dart';

import 'package:academic_planner/src/features/activity/domain/entities/activity.dart';

extension ActivityStatusExtension on ActivityStatus {
  String get label {
    return switch (this) {
      ActivityStatus.draft => "Rascunho",
      ActivityStatus.pending => "Pendente",
      ActivityStatus.inProgress => "Em Andamento",
      ActivityStatus.completed => "Concluído",
      ActivityStatus.canceled => "Cancelado",
    };
  }

  Color color(ColorScheme colorScheme) {
    return switch (this) {
      ActivityStatus.completed => Colors.teal,
      ActivityStatus.inProgress => colorScheme.secondary,
      ActivityStatus.canceled => colorScheme.error,
      ActivityStatus.draft => colorScheme.onSurface.withAlpha(120),
      ActivityStatus.pending => colorScheme.onSurface.withAlpha(100),
    };
  }
}
