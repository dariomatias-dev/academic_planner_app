import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/presentation/widgets/note_card_widget.dart';

import 'package:academic_planner/src/shared/widgets/states/states.dart';

final disciplineNotesProvider = FutureProvider.family<List<Note>, int>((
  ref,
  disciplineId,
) async {
  ref.watch(noteNotifierProvider);

  final notifier = ref.read(noteNotifierProvider.notifier);
  final result = await notifier.getAll();

  return result.fold(
    onSuccess: (notes) => notes,
    onFailure: (failure) => [],
  );
});

class DisciplineDetailsNotesTabWidget extends ConsumerWidget {
  final int disciplineId;

  const DisciplineDetailsNotesTabWidget({
    super.key,
    required this.disciplineId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(noteNotifierProvider, (_, _) {
      ref.invalidate(disciplineNotesProvider(disciplineId));
    });

    final notesAsync = ref.watch(disciplineNotesProvider(disciplineId));

    return notesAsync.when(
      loading: () {
        return const LoadingStateWidget(message: 'Obtendo anotações...');
      },
      error: (_, _) {
        return const ErrorStateWidget(
          description: 'Erro ao obter as anotações',
        );
      },
      data: (notes) {
        if (notes.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.edit_note_rounded,
            title: "Sem anotações",
            description: "Nenhuma anotação criada para esta disciplina.",
            actionLabel: "Criar Anotação",
            onActionPressed: () {
              AppRoutes.goToNoteForm(context, disciplineId: disciplineId);
            },
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 100.0),
          physics: const BouncingScrollPhysics(),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return NoteCardWidget(note: notes[index]);
          },
        );
      },
    );
  }
}
