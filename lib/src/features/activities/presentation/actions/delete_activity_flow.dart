import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';

import 'package:academic_planner/src/shared/actions/removal_flow.dart';

Future<bool> deleteActivityFlow({
  required BuildContext context,
  required WidgetRef ref,
  required Activity activity,
}) {
  final activityNotifier = ref.read(activityNotifierProvider.notifier);

  return removalFlow(
    context: context,
    confirmTitle: 'Excluir Atividade',
    confirmMessage:
        "Tem certeza que deseja excluir '${activity.title}'? Esta ação não poderá ser desfeita.",
    onDelete: () async {
      String? error;

      final result = await activityNotifier.delete(activity.id);

      result.when(onFailure: (f) => error = f.message);

      return error;
    },
    onSuccess: () => ref.invalidate(activityNotifierProvider),
    successTitle: 'Atividade Removida',
    successMessage:
        'A atividade foi excluída com sucesso do seu cronograma acadêmico.',
    failureMessage:
        'Não conseguimos remover a atividade no momento. Por favor, tente novamente em instantes.',
  );
}
