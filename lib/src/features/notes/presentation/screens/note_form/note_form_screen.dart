import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:logging/logging.dart';

import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/core/validators.dart';

import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/description/activity_form_description_field_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/activity_form_discipline_picker_widget.dart';
import 'package:academic_planner/src/features/disciplines/data/models/discipline_model.dart';
import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';

class NoteFormScreen extends ConsumerStatefulWidget {
  final String? noteId;
  final int disciplineId;

  const NoteFormScreen({super.key, this.noteId, required this.disciplineId});

  @override
  ConsumerState<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends ConsumerState<NoteFormScreen> {
  static final _log = Logger('notes.NoteFormScreen');

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  late final QuillController _contentController;

  final _disciplineNotifier = ValueNotifier<DisciplineModel?>(null);
  final _isLoadingNotifier = ValueNotifier<bool>(false);
  final _canSaveNotifier = ValueNotifier<bool>(false);

  Note? _initialNote;

  void _unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _updateChangeTracker() {
    _canSaveNotifier.value = _hasChanges();
  }

  bool _hasChanges() {
    if (_initialNote == null) return true;

    final currentContent = jsonEncode(
      _contentController.document.toDelta().toJson(),
    );

    final hasTitleChanged =
        _titleController.text.trim() != _initialNote!.title.trim();
    final hasContentChanged = currentContent != _initialNote!.content;
    final hasDisciplineChanged =
        _disciplineNotifier.value?.id != _initialNote!.disciplineId;

    return hasTitleChanged || hasContentChanged || hasDisciplineChanged;
  }

  Future<void> _saveNote() async {
    _unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      final noteNotifier = ref.read(noteNotifierProvider.notifier);

      final content = jsonEncode(
        _contentController.document.toDelta().toJson(),
      );

      Result<void> result;

      if (_initialNote != null) {
        final updatedNote = _initialNote!.copyWith(
          title: _titleController.text.trim(),
          content: content,
          disciplineId: _disciplineNotifier.value?.id,
        );

        result = await noteNotifier.edit(updatedNote);
      } else {
        final newNote = noteNotifier.createNew(
          title: _titleController.text.trim(),
          content: content,
          disciplineId: _disciplineNotifier.value!.id,
        );

        result = await noteNotifier.add(newNote);
      }

      result.fold(
        onSuccess: (data) {
          if (!mounted) return;

          ref.invalidate(noteNotifierProvider);

          Navigator.pop(context, true);
        },
        onFailure: (failure) {
          if (!mounted) return;

          Fluttertoast.showToast(msg: 'Erro ao salvar anotação');
        },
      );
    }
  }

  Future<void> _loadNote() async {
    final noteNotifier = ref.read(noteNotifierProvider.notifier);

    if (widget.noteId == null) {
      _disciplineNotifier.value = adsDisciplines.where((d) {
        return d.id == widget.disciplineId;
      }).firstOrNull;

      _updateChangeTracker();

      return;
    }

    _isLoadingNotifier.value = true;

    final result = await noteNotifier.getById(widget.noteId!);

    result.fold(
      onSuccess: (note) {
        if (!mounted || note == null) return;

        _initialNote = note;
        _titleController.text = note.title;

        try {
          final doc = Document.fromJson(jsonDecode(note.content));

          _contentController.document = doc;
          _contentController.updateSelection(
            const TextSelection.collapsed(offset: 0),

            ChangeSource.local,
          );

          _unfocus();
        } catch (err, stackTrace) {
          _log.severe('Failed to parse content', err, stackTrace);
        }

        _disciplineNotifier.value = adsDisciplines.where((d) {
          return d.id == note.disciplineId;
        }).firstOrNull;

        _updateChangeTracker();
      },
      onFailure: (failure) {
        if (!mounted) return;

        Fluttertoast.showToast(msg: 'Erro ao carregar anotação');
      },
    );

    if (mounted) _isLoadingNotifier.value = false;
  }

  @override
  void initState() {
    super.initState();

    _contentController = QuillController.basic();
    _contentController.addListener(_updateChangeTracker);
    _titleController.addListener(_updateChangeTracker);

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadNote());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _disciplineNotifier.dispose();
    _isLoadingNotifier.dispose();
    _canSaveNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.noteId != null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: isEditing ? "Editar Anotação" : "Nova Anotação",
        actions: <Widget>[
          ValueListenableBuilder<bool>(
            valueListenable: _canSaveNotifier,
            builder: (context, canSave, child) {
              return IconButtonWidget(
                icon: Icons.check_rounded,
                onPressed: canSave ? _saveNote : null,
                style: IconButtonStyle.primary,
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _isLoadingNotifier,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return const LoadingStateWidget();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 120.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const FormSectionTitleWidget(
                    title: "Informações",
                    padding: EdgeInsets.only(bottom: 16.0),
                  ),
                  _NoteFormInputFieldWidget(
                    controller: _titleController,
                    label: "Título",
                    hint: "Sobre o que é esta anotação?",
                    isRequired: true,
                    validator: (value) {
                      return Validators.required(
                        value?.trim(),
                        message: "O título é obrigatório",
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ValueListenableBuilder<DisciplineModel?>(
                    valueListenable: _disciplineNotifier,
                    builder: (context, discipline, child) {
                      return ActivityFormDisciplinePickerWidget(
                        selectedDiscipline: discipline,
                        isRequired: true,
                        onSelected: (value) {
                          _disciplineNotifier.value = value;
                          _updateChangeTracker();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32.0),
                  const FormSectionTitleWidget(
                    title: "Conteúdo",
                    padding: EdgeInsets.only(bottom: 16.0),
                  ),
                  ActivityFormDescriptionFieldWidget(
                    controller: _contentController,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NoteFormInputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isRequired;
  final String? Function(String? value)? validator;

  const _NoteFormInputFieldWidget({
    required this.controller,
    required this.label,
    required this.hint,
    this.isRequired = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormFieldLabelWidget(label: label, isRequired: isRequired),
        const SizedBox(height: 8.0),
        InputWidget(controller: controller, hint: hint, validator: validator),
      ],
    );
  }
}
