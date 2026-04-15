import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

import 'package:academic_planner/src/controllers/activity_controller.dart';

import 'package:academic_planner/src/core/validators.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/activity_status_extension.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/providers/activity_providers.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/activity_form/widgets/activity_form_date_picker_widget.dart';
import 'package:academic_planner/src/features/activity_form/widgets/activity_form_description_field/activity_form_description_field_widget.dart';
import 'package:academic_planner/src/features/activity_form/widgets/activity_form_discipline_picker_widget.dart';
import 'package:academic_planner/src/features/activity_form/widgets/activity_reminders/activity_form_reminders_widget.dart';
import 'package:academic_planner/src/features/activity_form/widgets/create_category_dialog_widget.dart';
import 'package:academic_planner/src/features/activity_form/widgets/create_tag_dialog_widget.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/models/discipline_model.dart';
import 'package:academic_planner/src/shared/models/optional.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/filter_chip_widget.dart';
import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';
import 'package:academic_planner/src/shared/widgets/selectable_chip_widget.dart';

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
  late final ActivityController _activityController;
  final _logger = Logger();

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  late final QuillController _descriptionController;

  final _disciplineNotifier = ValueNotifier<DisciplineModel?>(null);
  final _dueDateNotifier = ValueNotifier<DateTime?>(null);
  final _statusNotifier = ValueNotifier<ActivityStatus>(ActivityStatus.draft);
  final _categoryNotifier = ValueNotifier<String?>(null);
  final _categoriesNotifier = ValueNotifier<List<String>>(<String>[
    "Estudo",
    "Leitura",
    "Projeto",
    "Prova",
  ]);
  final _tagsNotifier = ValueNotifier<List<String>>(<String>[]);
  final _availableTagsNotifier = ValueNotifier<List<String>>(<String>[
    "Urgente",
    "Teórica",
    "Prática",
    "Grupo",
  ]);
  final _remindersNotifier = ValueNotifier<List<TimeOfDay>>(<TimeOfDay>[]);
  final _isLoadingNotifier = ValueNotifier<bool>(false);
  final _canSaveNotifier = ValueNotifier<bool>(false);

  ActivityModel? _initialActivity;

  void _unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  bool _isSameDay(DateTime? d1, DateTime? d2) {
    if (d1 == null && d2 == null) return true;
    if (d1 == null || d2 == null) return false;

    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  void _updateChangeTracker() {
    _canSaveNotifier.value = _hasChanges();
  }

  bool _hasChanges() {
    if (_initialActivity == null) return true;

    final currentDescription = jsonEncode(
      _descriptionController.document.toDelta().toJson(),
    );
    final initialDescription = _initialActivity!.description;

    final hasTitleChanged =
        _titleController.text.trim() != _initialActivity!.title.trim();
    final hasDescriptionChanged = currentDescription != initialDescription;
    final hasNotesChanged =
        _notesController.text.trim() != (_initialActivity!.notes?.trim() ?? "");
    final hasDisciplineChanged =
        _disciplineNotifier.value?.id != _initialActivity!.disciplineId;

    final hasDueDateChanged = !_isSameDay(
      _dueDateNotifier.value,
      _initialActivity!.dueDate,
    );

    final initialStatus = _initialActivity!.status ?? ActivityStatus.draft;
    final hasStatusChanged = _statusNotifier.value != initialStatus;

    final hasCategoryChanged =
        _categoryNotifier.value != _initialActivity!.category;

    final hasTagsChanged =
        !(_tagsNotifier.value.length == _initialActivity!.tags.length &&
            _tagsNotifier.value.every(
              (t) => _initialActivity!.tags.contains(t),
            ));

    final hasRemindersChanged =
        !(_remindersNotifier.value.length ==
                _initialActivity!.reminders.length &&
            _remindersNotifier.value.every(
              (r) => _initialActivity!.reminders.contains(r),
            ));

    return hasTitleChanged ||
        hasDescriptionChanged ||
        hasNotesChanged ||
        hasDisciplineChanged ||
        hasDueDateChanged ||
        hasStatusChanged ||
        hasCategoryChanged ||
        hasTagsChanged ||
        hasRemindersChanged;
  }

  void _showCreateCategoryDialog() {
    _unfocus();

    showDialog(
      context: context,
      builder: (context) {
        return CreateCategoryDialogWidget(
          onCategoryAdded: (categoryName) {
            _categoriesNotifier.value = <String>[
              ..._categoriesNotifier.value,
              categoryName,
            ];

            _categoryNotifier.value = categoryName;

            _updateChangeTracker();
          },
        );
      },
    );
  }

  void _showCreateTagDialog() {
    _unfocus();

    showDialog(
      context: context,
      builder: (context) {
        return CreateTagDialogWidget(
          onTagAdded: (tagName) {
            _availableTagsNotifier.value = <String>[
              ..._availableTagsNotifier.value,
              tagName,
            ];

            _tagsNotifier.value = <String>[..._tagsNotifier.value, tagName];

            _updateChangeTracker();
          },
        );
      },
    );
  }

  Future<void> _selectDate() async {
    _unfocus();

    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDateNotifier.value ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      _dueDateNotifier.value = picked;

      _updateChangeTracker();
    }

    _unfocus();
  }

  Future<void> _addReminder() async {
    _unfocus();

    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 30),
    );

    if (picked != null && !_remindersNotifier.value.contains(picked)) {
      _remindersNotifier.value = <TimeOfDay>[
        ..._remindersNotifier.value,
        picked,
      ];

      _updateChangeTracker();
    }
  }

  Future<void> _saveTask() async {
    _unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      final description = jsonEncode(
        _descriptionController.document.toDelta().toJson(),
      );

      Result<void> result;

      if (_initialActivity != null) {
        final updatedActivity = _initialActivity!.copyWith(
          title: _titleController.text.trim(),
          description: description,
          notes: _notesController.text.trim(),
          disciplineId: _disciplineNotifier.value?.id,
          dueDate: Optional(_dueDateNotifier.value),
          category: _categoryNotifier.value,
          tags: _tagsNotifier.value,
          reminders: _remindersNotifier.value,
          status: _statusNotifier.value,
        );

        result = await _activityController.editActivity(updatedActivity);
      } else {
        result = await _activityController.createActivity(
          title: _titleController.text.trim(),
          description: description,
          notes: _notesController.text.trim(),
          disciplineId: _disciplineNotifier.value!.id,
          dueDate: _dueDateNotifier.value,
          category: _categoryNotifier.value,
          tags: _tagsNotifier.value,
          reminders: _remindersNotifier.value,
          status: _statusNotifier.value,
        );
      }

      result.fold(
        onSuccess: (_) => Navigator.pop(context, true),
        onFailure: (failure) {
          Fluttertoast.showToast(msg: 'Erro ao salvar: ${failure.toString()}');
        },
      );
    }
  }

  Future<void> _loadActivity() async {
    if (widget.activityId == null) {
      if (widget.initialDisciplineId != null) {
        _disciplineNotifier.value = adsDisciplines
            .where((d) => d.id == widget.initialDisciplineId)
            .firstOrNull;
      }

      _updateChangeTracker();

      return;
    }

    _isLoadingNotifier.value = true;

    final result = await _activityController.getActivityById(
      widget.activityId!,
    );

    result.fold(
      onSuccess: (activity) {
        if (!mounted) return;

        if (activity != null) {
          _initialActivity = activity;
          _titleController.text = activity.title;
          _notesController.text = activity.notes ?? "";

          try {
            final doc = Document.fromJson(jsonDecode(activity.description));

            _descriptionController.document = doc;
            _descriptionController.updateSelection(
              const TextSelection.collapsed(offset: 0),
              ChangeSource.local,
            );

            _unfocus();
          } catch (err, stackTrace) {
            _logger.e(
              'Failed to parse description',
              error: err,
              stackTrace: stackTrace,
            );
          }

          _disciplineNotifier.value = adsDisciplines
              .where((d) => d.id == activity.disciplineId)
              .firstOrNull;
          _dueDateNotifier.value = activity.dueDate;
          _statusNotifier.value = activity.status ?? ActivityStatus.draft;
          _categoryNotifier.value = activity.category;
          _tagsNotifier.value = List<String>.from(activity.tags);
          _remindersNotifier.value = List<TimeOfDay>.from(activity.reminders);

          final newAvailableTags = List<String>.from(
            _availableTagsNotifier.value,
          );

          for (final tag in activity.tags) {
            if (!newAvailableTags.contains(tag)) newAvailableTags.add(tag);
          }

          _availableTagsNotifier.value = newAvailableTags;

          if (activity.category != null &&
              !_categoriesNotifier.value.contains(activity.category)) {
            _categoriesNotifier.value = <String>[
              ..._categoriesNotifier.value,
              activity.category!,
            ];
          }

          _updateChangeTracker();
        }
      },
      onFailure: (failure) {
        Fluttertoast.showToast(msg: 'Erro ao carregar atividade');
      },
    );

    _isLoadingNotifier.value = false;
  }

  @override
  void initState() {
    super.initState();
    _activityController = ref.read(activityControllerProvider);
    _descriptionController = QuillController.basic();

    _descriptionController.addListener(_updateChangeTracker);
    _titleController.addListener(_updateChangeTracker);
    _notesController.addListener(_updateChangeTracker);

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadActivity());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _disciplineNotifier.dispose();
    _dueDateNotifier.dispose();
    _statusNotifier.dispose();
    _categoryNotifier.dispose();
    _categoriesNotifier.dispose();
    _tagsNotifier.dispose();
    _availableTagsNotifier.dispose();
    _remindersNotifier.dispose();
    _isLoadingNotifier.dispose();
    _canSaveNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.activityId != null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: isEditing ? "Editar Atividade" : "Criar Atividade",
        actions: <Widget>[
          ValueListenableBuilder<bool>(
            valueListenable: _canSaveNotifier,
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
        valueListenable: _isLoadingNotifier,
        builder: (context, isLoading, _) {
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
                    title: "Conteúdo",
                    padding: EdgeInsets.only(bottom: 16.0),
                  ),
                  ActivityFormInputFieldWidget(
                    controller: _titleController,
                    label: "Título",
                    hint: "O que deve ser feito?",
                    isRequired: true,
                    validator: (value) {
                      return Validators.required(
                        value?.trim(),
                        message: "O título é obrigatório",
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ActivityFormDescriptionFieldWidget(
                    controller: _descriptionController,
                  ),
                  const FormSectionTitleWidget(title: "Classificação"),
                  ValueListenableBuilder<DisciplineModel?>(
                    valueListenable: _disciplineNotifier,
                    builder: (context, discipline, _) {
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
                  const SizedBox(height: 20.0),
                  ValueListenableBuilder<ActivityStatus>(
                    valueListenable: _statusNotifier,
                    builder: (context, status, _) {
                      return ActivityFormStatusSelectorWidget(
                        selectedStatus: status,
                        onSelect: (value) {
                          _statusNotifier.value = value;

                          _updateChangeTracker();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ValueListenableBuilder<List<String>>(
                    valueListenable: _categoriesNotifier,
                    builder: (context, categories, _) {
                      return ValueListenableBuilder<String?>(
                        valueListenable: _categoryNotifier,
                        builder: (context, selectedCategory, _) {
                          return ActivityFormCategorySelectorWidget(
                            categories: categories,
                            selectedCategory: selectedCategory,
                            onSelect: (value) {
                              _categoryNotifier.value = value;

                              _updateChangeTracker();
                            },
                            onCreate: _showCreateCategoryDialog,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ValueListenableBuilder<List<String>>(
                    valueListenable: _availableTagsNotifier,
                    builder: (context, available, _) {
                      return ValueListenableBuilder<List<String>>(
                        valueListenable: _tagsNotifier,
                        builder: (context, selected, _) {
                          return ActivityFormTagSelectorWidget(
                            availableTags: available,
                            selectedTags: selected,
                            onToggle: (tag, value) {
                              final current = List<String>.from(
                                _tagsNotifier.value,
                              );

                              value ? current.add(tag) : current.remove(tag);

                              _tagsNotifier.value = current;

                              _updateChangeTracker();
                            },
                            onCreate: _showCreateTagDialog,
                          );
                        },
                      );
                    },
                  ),
                  const FormSectionTitleWidget(title: "Prazos e Lembretes"),
                  ValueListenableBuilder<DateTime?>(
                    valueListenable: _dueDateNotifier,
                    builder: (context, date, _) {
                      return ActivityFormDatePickerWidget(
                        dueDate: date,
                        isRequired: false,
                        onTap: _selectDate,
                        onClear: () {
                          _dueDateNotifier.value = null;

                          _updateChangeTracker();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ValueListenableBuilder<List<TimeOfDay>>(
                    valueListenable: _remindersNotifier,
                    builder: (context, reminders, _) {
                      return ActivityFormRemindersWidget(
                        reminders: reminders,
                        onAdd: _addReminder,
                        onRemove: (time) {
                          final current = List<TimeOfDay>.from(
                            _remindersNotifier.value,
                          );

                          current.remove(time);

                          _remindersNotifier.value = current;

                          _updateChangeTracker();
                        },
                      );
                    },
                  ),
                  const FormSectionTitleWidget(title: "Anotações"),
                  InputWidget(
                    controller: _notesController,
                    hint: "Rascunhos ou lembretes rápidos...",
                    maxLines: 5,
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

class ActivityFormInputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final bool isRequired;
  final String? Function(String? value)? validator;

  const ActivityFormInputFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
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
        InputWidget(
          controller: controller,
          hint: hint,
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }
}

class ActivityFormStatusSelectorWidget extends StatelessWidget {
  final ActivityStatus selectedStatus;
  final void Function(ActivityStatus value) onSelect;

  const ActivityFormStatusSelectorWidget({
    super.key,
    required this.selectedStatus,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const FormFieldLabelWidget(label: "Status", isRequired: true),
        const SizedBox(height: 12.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8.0,
            children: ActivityStatus.values.builder((status, index) {
              final isSelected = selectedStatus == status;

              return SelectableChipWidget(
                onTap: () => onSelect(status),
                label: status.label,
                isSelected: isSelected,
              );
            }),
          ),
        ),
      ],
    );
  }
}

class ActivityFormCategorySelectorWidget extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final void Function(String? value) onSelect;
  final VoidCallback onCreate;
  final bool isRequired;

  const ActivityFormCategorySelectorWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
    required this.onCreate,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FormFieldLabelWidget(label: "Categoria", isRequired: isRequired),
            GestureDetector(
              onTap: onCreate,
              child: Text(
                "+ Nova Categoria",
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.primary,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8.0,
            children: categories.builder((category, index) {
              final isSelected = selectedCategory == category;

              return SelectableChipWidget(
                onTap: () => onSelect(isSelected ? null : category),
                label: category,
                isSelected: isSelected,
              );
            }),
          ),
        ),
      ],
    );
  }
}

class ActivityFormTagSelectorWidget extends StatelessWidget {
  final List<String> availableTags;
  final List<String> selectedTags;
  final Function(String tag, bool value) onToggle;
  final VoidCallback onCreate;

  const ActivityFormTagSelectorWidget({
    super.key,
    required this.availableTags,
    required this.selectedTags,
    required this.onToggle,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Tags",
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: onCreate,
              child: Text(
                "+ Nova Tag",
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.primary,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: availableTags.builder((tag, index) {
            final isSelected = selectedTags.contains(tag);

            return FilterChipWidget(
              label: tag,
              isSelected: isSelected,
              onSelected: (value) => onToggle(tag, value),
            );
          }),
        ),
      ],
    );
  }
}
