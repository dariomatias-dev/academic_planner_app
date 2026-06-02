import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';

import 'package:academic_planner/src/shared/actions/removal_flow.dart';

Future<bool> deleteNoteFlow({
  required BuildContext context,
  required WidgetRef ref,
  required Note note,
}) {
  final noteNotifier = ref.read(noteNotifierProvider.notifier);

  return removalFlow(
    context: context,
    confirmTitle: 'Excluir Anotação',
    confirmMessage:
        "Tem certeza que deseja excluir '${note.title}'? Esta ação não poderá ser desfeita.",
    onDelete: () => resultToError(noteNotifier.delete(note.id)),
    successTitle: 'Anotação Removida',
    successMessage: 'A anotação foi excluída com sucesso da sua base de dados.',
    failureMessage:
        'Não conseguimos remover a anotação no momento. Por favor, tente novamente em instantes.',
  );
}
