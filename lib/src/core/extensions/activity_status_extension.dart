import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';

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
      ActivityStatus.completed => AppColors.emerald900,
      ActivityStatus.inProgress => AppColors.emerald400,
      ActivityStatus.pending => AppColors.slate700,
      ActivityStatus.canceled => AppColors.red600,
      ActivityStatus.draft => AppColors.slate300,
    };
  }
}
