import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_order.dart';

enum ActivitySortField {
  title,
  dueDate,
  createdAt,
  updatedAt;

  String get label {
    return switch (this) {
      ActivitySortField.title => 'Título',
      ActivitySortField.dueDate => 'Data de Entrega',
      ActivitySortField.createdAt => 'Data de Criação',
      ActivitySortField.updatedAt => 'Última Atualização',
    };
  }

  String get column {
    return switch (this) {
      ActivitySortField.title => 'title',
      ActivitySortField.dueDate => 'dueDate',
      ActivitySortField.createdAt => 'createdAt',
      ActivitySortField.updatedAt => 'updatedAt',
    };
  }

  ActivitySortOrder get defaultOrder {
    return switch (this) {
      ActivitySortField.title => ActivitySortOrder.asc,
      ActivitySortField.dueDate => ActivitySortOrder.asc,
      ActivitySortField.createdAt => ActivitySortOrder.desc,
      ActivitySortField.updatedAt => ActivitySortOrder.desc,
    };
  }
}
