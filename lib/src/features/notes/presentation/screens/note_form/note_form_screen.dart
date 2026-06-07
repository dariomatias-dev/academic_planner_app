import 'package:academic_planner/src/core/validators.dart';
import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/presentation/view_models/note_form_view_model.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NoteFormScreen extends ConsumerStatefulWidget {
  const NoteFormScreen({required this.disciplineId, super.key, this.noteId});

  final String? noteId;
  final int disciplineId;

  @override
  ConsumerState<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends ConsumerState<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final NoteFormViewModel _viewModel;

  void _unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _saveNote() async {
    _unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final result = await _viewModel.save();

    await result.fold(
      onSuccess: (_) {
        if (!mounted) return;

        ref.invalidate(noteNotifierProvider);

        Navigator.pop(context, true);
      },
      onFailure: (_) async {
        if (!mounted) return;

        await Fluttertoast.showToast(msg: 'Erro ao salvar anotação');
      },
    );
  }

  Future<void> _loadNote() async {
    final result = await _viewModel.load(
      noteId: widget.noteId,
      disciplineId: widget.disciplineId,
    );

    result.fold(
      onSuccess: (_) => _unfocus(),
      onFailure: (_) async {
        if (!mounted) return;

        await Fluttertoast.showToast(msg: 'Erro ao carregar anotação');
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _viewModel = NoteFormViewModel(ref.read(noteNotifierProvider.notifier));

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadNote());
  }

  @override
  void dispose() {
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.noteId != null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: isEditing ? 'Editar Anotação' : 'Nova Anotação',
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _viewModel.canSave,
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
        valueListenable: _viewModel.isLoading,
        builder: (context, isLoading, child) {
          if (isLoading) return const LoadingStateWidget();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 120.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormSectionTitleWidget(
                    title: 'Informações',
                    padding: EdgeInsets.only(bottom: 16.0),
                  ),
                  InputFieldWidget(
                    controller: _viewModel.titleController,
                    label: 'Título',
                    hint: 'Sobre o que é esta anotação?',
                    isRequired: true,
                    validator: (value) {
                      return Validators.required(
                        value?.trim(),
                        message: 'O título é obrigatório',
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ValueListenableBuilder(
                    valueListenable: _viewModel.discipline,
                    builder: (context, discipline, child) {
                      return DisciplinePickerFieldWidget(
                        selectedDiscipline: discipline,
                        isRequired: true,
                        onSelected: _viewModel.setDiscipline,
                      );
                    },
                  ),
                  const SizedBox(height: 32.0),
                  const FormSectionTitleWidget(
                    title: 'Conteúdo',
                    padding: EdgeInsets.only(bottom: 16.0),
                  ),
                  RichTextFieldWidget(
                    controller: _viewModel.contentController,
                    label: 'Conteúdo',
                    placeholder: 'Escreva o conteúdo da sua anotação...',
                    validatorMessage: 'O conteúdo é obrigatório',
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
