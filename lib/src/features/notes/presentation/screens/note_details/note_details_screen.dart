import 'dart:convert';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_discipline_widget.dart';
import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/presentation/actions/delete_note_flow.dart';
import 'package:academic_planner/src/shared/utils/open_url.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/metadata_card/metadata_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/popup_menu/popup_menu.dart';
import 'package:academic_planner/src/shared/widgets/states/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final FutureProvider<Note?> Function(String) noteDetailProvider =
    FutureProvider.family<Note?, String>((
      ref,
      noteId,
    ) async {
      ref.watch(noteNotifierProvider);

      final notifier = ref.read(noteNotifierProvider.notifier);
      final result = await notifier.getById(noteId);

      return result.fold(onSuccess: (note) => note, onFailure: (_) => null);
    });

class NoteDetailsScreen extends ConsumerWidget {
  const NoteDetailsScreen({required this.noteId, super.key});

  final String noteId;

  Future<void> _deleteNote(
    BuildContext context,
    WidgetRef ref,
    Note note,
  ) async {
    final deleted = await deleteNoteFlow(
      context: context,
      ref: ref,
      note: note,
    );

    if (deleted && context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final noteAsync = ref.watch(noteDetailProvider(noteId));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: noteAsync.value?.title ?? 'Detalhes',
        actions: [
          noteAsync.maybeWhen(
            data: (note) => note == null
                ? const SizedBox.shrink()
                : PopupMenuWidget(
                    items: [
                      PopupMenuActions.edit(
                        onTap: () async {
                          await AppRoutes.goToNoteForm(
                            context,
                            noteId: note.id,
                            disciplineId: note.disciplineId,
                          );
                        },
                      ),
                      PopupMenuActions.delete(
                        onTap: () async {
                          await _deleteNote(context, ref, note);
                        },
                        color: colorScheme.error,
                      ),
                    ],
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: noteAsync.when(
        loading: () {
          return const LoadingStateWidget();
        },
        error: (_, _) {
          return EmptyStateWidget(
            icon: Icons.error_outline_rounded,
            title: 'Erro ao carregar',
            description: 'Não foi possível carregar os detalhes desta nota.',
            actionLabel: 'Tentar novamente',
            onActionPressed: () {
              ref.invalidate(noteDetailProvider(noteId));
            },
          );
        },
        data: (note) {
          if (note == null) {
            return const EmptyStateWidget(
              icon: Icons.notes_rounded,
              title: 'Anotação não encontrada',
              description: 'Os dados desta anotação não estão disponíveis.',
            );
          }

          final discipline = adsDisciplines
              .where((d) => d.id == note.disciplineId)
              .firstOrNull;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (discipline != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      discipline.acronym.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        color: colorScheme.primary,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
                Text(
                  note.title,
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.onSurface,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 32.0),
                const _NoteSectionTitleWidget(title: 'Conteúdo'),
                NoteDetailsDescriptionWidget(description: note.content),
                if (discipline != null) ...[
                  const SizedBox(height: 32.0),
                  const _NoteSectionTitleWidget(title: 'Disciplina'),
                  ActivityDetailsDisciplineWidget(discipline: discipline),
                ],
                const SizedBox(height: 48.0),
                const _NoteSectionTitleWidget(title: 'Metadados'),
                MetadataCardWidget(
                  createdAt: note.createdAt,
                  updatedAt: note.updatedAt,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NoteSectionTitleWidget extends StatelessWidget {
  const _NoteSectionTitleWidget({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11.0,
          fontWeight: FontWeight.w900,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class NoteDetailsDescriptionWidget extends ConsumerStatefulWidget {
  const NoteDetailsDescriptionWidget({required this.description, super.key});

  final String description;

  @override
  ConsumerState<NoteDetailsDescriptionWidget> createState() =>
      _NoteDetailsDescriptionWidgetState();
}

class _NoteDetailsDescriptionWidgetState
    extends ConsumerState<NoteDetailsDescriptionWidget> {
  late QuillController _quillController;

  void _initializeController() {
    if (widget.description.startsWith('[') ||
        widget.description.startsWith('{')) {
      _quillController = QuillController(
        document: Document.fromJson(
          jsonDecode(widget.description) as List<dynamic>,
        ),
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      );
    } else {
      final doc = Document()..insert(0, widget.description);
      _quillController = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _initializeController();
  }

  @override
  void didUpdateWidget(covariant NoteDetailsDescriptionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.description != widget.description) {
      _initializeController();
    }
  }

  @override
  void dispose() {
    _quillController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final defaultStyles = DefaultStyles(
      paragraph: DefaultTextBlockStyle(
        GoogleFonts.plusJakartaSans(
          fontSize: 16.0,
          color: colorScheme.onSurface.withAlpha(180),
          height: 1.6,
        ),
        HorizontalSpacing.zero,
        VerticalSpacing.zero,
        VerticalSpacing.zero,
        null,
      ),
      link: GoogleFonts.plusJakartaSans(
        color: colorScheme.primary,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.underline,
      ),
    );

    return QuillEditor(
      controller: _quillController,
      scrollController: ScrollController(),
      focusNode: FocusNode(),
      config: QuillEditorConfig(
        scrollable: false,
        showCursor: false,
        customStyles: defaultStyles,
        onLaunchUrl: (url) async {
          await openUrl(context, url);
        },
      ),
    );
  }
}
