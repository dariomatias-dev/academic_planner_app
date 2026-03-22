import 'package:academic_planner/src/shared/models/activity_model.dart';

final mockActivities = <ActivityModel>[
  ActivityModel(
    title: "Protótipo High-Fi",
    deadline: DateTime.now().add(const Duration(days: 2)),
    disciplineId: 53,
    priority: "Alta",
  ),
  ActivityModel(
    title: "Configuração de Rotas",
    deadline: DateTime.now().add(const Duration(days: 1)),
    disciplineId: 52,
    priority: "Alta",
  ),
  ActivityModel(
    title: "Lista de Exercícios IA",
    deadline: DateTime.now().add(const Duration(days: 4)),
    disciplineId: 54,
    priority: "Média",
  ),
];
