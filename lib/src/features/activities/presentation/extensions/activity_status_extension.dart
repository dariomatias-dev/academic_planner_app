import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

extension ActivityStatusExtension on ActivityStatus {
  String get label {
    return switch (this) {
      ActivityStatus.draft => 'Rascunho',
      ActivityStatus.pending => 'Pendente',
      ActivityStatus.inProgress => 'Em Andamento',
      ActivityStatus.completed => 'Concluído',
      ActivityStatus.canceled => 'Cancelado',
    };
  }

  Color color(ColorScheme colorScheme) {
    return switch (this) {
      ActivityStatus.completed => AppPalette.emerald900,
      ActivityStatus.inProgress => AppPalette.emerald400,
      ActivityStatus.pending => AppPalette.slate700,
      ActivityStatus.canceled => AppPalette.red600,
      ActivityStatus.draft => AppPalette.slate300,
    };
  }
}
