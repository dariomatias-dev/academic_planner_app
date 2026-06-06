import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/presentation/view_models/activity_form_view_model.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/sections/activity_form_classification_section_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/sections/activity_form_content_section_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/sections/activity_form_deadlines_section_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/sections/activity_form_notes_section_widget.dart';
import 'package:academic_planner/src/features/categories/presentation/widgets/dialogs/category_form_dialog_widget.dart';
import 'package:academic_planner/src/features/tags/presentation/widgets/dialogs/tag_form_dialog_widget.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';

class ActivityFormScreen extends ConsumerStatefulWidget {
  final String? activityId;
  final int? initialDisciplineId;

  const ActivityFormScreen({
    super.key,
    this.activityId,
    this.initialDisciplineId,
  });

  @override
  ConsumerState<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends ConsumerState<ActivityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final ActivityFormViewModel _viewModel;

  void _unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _showCreateCategoryDialog() {
    _unfocus();

    CategoryFormDialogWidget.show(context);
  }

  void _showCreateTagDialog() {
    _unfocus();

    TagFormDialogWidget.show(context);
  }

  Future<void> _selectDate() async {
    _unfocus();

    final picked = await showDatePicker(
      context: context,
      initialDate: _viewModel.dueDate.value ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );

    if (picked != null) _viewModel.setDueDate(picked);

    _unfocus();
  }

  Future<void> _addReminder() async {
    _unfocus();

    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 30),
    );

    if (picked != null) _viewModel.addReminder(picked);
  }

  Future<void> _saveTask() async {
    _unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final result = await _viewModel.save();

    result.fold(
      onSuccess: (_) {
        if (!mounted) return;
        ref.invalidate(activityNotifierProvider);
        Navigator.pop(context, true);
      },
      onFailure: (_) => Fluttertoast.showToast(msg: 'Erro ao salvar atividade'),
    );
  }

  Future<void> _loadActivity() async {
    final result = await _viewModel.load(
      activityId: widget.activityId,
      initialDisciplineId: widget.initialDisciplineId,
    );

    result.fold(
      onSuccess: (_) {},
      onFailure: (_) {
        if (!mounted) return;

        Fluttertoast.showToast(msg: 'Erro ao carregar atividade');
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _viewModel = ActivityFormViewModel(
      ref.read(activityNotifierProvider.notifier),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadActivity());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.activityId != null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: isEditing ? "Editar Atividade" : "Criar Atividade",
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _viewModel.canSave,
            builder: (context, canSave, _) {
              return IconButtonWidget(
                icon: Icons.check_rounded,
                onPressed: canSave ? _saveTask : null,
                style: IconButtonStyle.primary,
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _viewModel.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) return const LoadingStateWidget();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 120.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ActivityFormContentSectionWidget(
                    titleController: _viewModel.titleController,
                    descriptionController: _viewModel.descriptionController,
                  ),
                  ActivityFormClassificationSectionWidget(
                    discipline: _viewModel.discipline,
                    onDisciplineSelected: _viewModel.setDiscipline,
                    status: _viewModel.status,
                    onStatusSelected: _viewModel.setStatus,
                    category: _viewModel.category,
                    onCategorySelected: _viewModel.setCategory,
                    onCreateCategory: _showCreateCategoryDialog,
                    tags: _viewModel.tags,
                    onTagToggled: _viewModel.toggleTag,
                    onCreateTag: _showCreateTagDialog,
                  ),
                  ActivityFormDeadlinesSectionWidget(
                    dueDate: _viewModel.dueDate,
                    onSelectDate: _selectDate,
                    onClearDate: () => _viewModel.setDueDate(null),
                    reminders: _viewModel.reminders,
                    onAddReminder: _addReminder,
                    onRemoveReminder: _viewModel.removeReminder,
                  ),
                  ActivityFormNotesSectionWidget(
                    controller: _viewModel.notesController,
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
