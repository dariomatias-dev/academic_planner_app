import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';

import 'package:academic_planner/src/shared/widgets/popup_menu/popup_menu.dart';
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
    onFailure: (failure) => <Note>[],
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
            return _NoteCardWidget(note: notes[index]);
          },
        );
      },
    );
  }
}

class _NoteCardWidget extends ConsumerWidget {
  final Note note;

  const _NoteCardWidget({required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        AppRoutes.goToNoteDetails(context, noteId: note.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28.0),
          border: Border.all(
            color: theme.dividerTheme.color ?? Colors.transparent,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    note.title,
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onSurface,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuWidget<VoidCallback>(
                  onSelected: (action) => action(),
                  items: <PopupMenuEntry<VoidCallback>>[
                    PopupMenuItem<VoidCallback>(
                      value: () {
                        AppRoutes.goToNoteForm(
                          context,
                          noteId: note.id,
                          disciplineId: note.disciplineId,
                        );
                      },
                      height: 48.0,
                      child: const PopupMenuActionWidget(
                        icon: Icons.edit_outlined,
                        label: "Editar",
                      ),
                    ),
                    PopupMenuItem<VoidCallback>(
                      value: () async {
                        await ref
                            .read(noteNotifierProvider.notifier)
                            .delete(note.id);
                      },
                      height: 48.0,
                      child: PopupMenuActionWidget(
                        icon: Icons.delete_outline_rounded,
                        label: "Excluir",
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              "Toque para visualizar o conteúdo completo da anotação...",
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface.withAlpha(160),
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 12.0,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    DateFormat(
                      "dd 'de' MMMM, yyyy",
                      'pt_BR',
                    ).format(note.updatedAt),
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.primary,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
