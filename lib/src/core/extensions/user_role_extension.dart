import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

extension UserRoleExtension on UserRole {
  Color getColor(ColorScheme colorScheme) {
    return switch (this) {
      UserRole.admin => colorScheme.primary,
      UserRole.teacher => Colors.teal,
      UserRole.student => colorScheme.secondary,
    };
  }

  String get label {
    return switch (this) {
      UserRole.admin => 'administrador',
      UserRole.teacher => 'professor',
      UserRole.student => 'aluno',
    };
  }

  IconData get icon {
    return switch (this) {
      UserRole.admin => Icons.admin_panel_settings_rounded,
      UserRole.teacher => Icons.school_rounded,
      UserRole.student => Icons.person_rounded,
    };
  }
}
