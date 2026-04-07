import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:academic_planner/src/controllers/activity_controller.dart';

import 'package:academic_planner/src/core/app_validators.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/activity_status_extension.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/screens/activity_form/widgets/activity_form_date_picker_widget.dart';
import 'package:academic_planner/src/screens/activity_form/widgets/activity_form_description_field/activity_form_description_field_widget.dart';
import 'package:academic_planner/src/screens/activity_form/widgets/activity_form_discipline_picker/activity_form_discipline_picker_widget.dart';
import 'package:academic_planner/src/screens/activity_form/widgets/activity_form_section_title_widget.dart';
import 'package:academic_planner/src/screens/activity_form/widgets/activity_reminders/activity_form_reminders_widget.dart';
import 'package:academic_planner/src/screens/activity_form/widgets/create_category_dialog_widget.dart';
import 'package:academic_planner/src/screens/activity_form/widgets/create_tag_dialog_widget.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/models/discipline_model.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/filter_chip_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/selectable_chip_widget.dart';

class ActivityFormScreen extends StatefulWidget {
  final String? activityId;
  final int? initialDisciplineId;

  const ActivityFormScreen({
    super.key,
    this.activityId,
    this.initialDisciplineId,
  });

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  late final _activityController = context.read<ActivityController>();
  final _logger = Logger();

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  late QuillController _descriptionController;
  final _notesController = TextEditingController();
  final _reminders = <TimeOfDay>[];

  ActivityModel? _initialActivity;
  DisciplineModel? _selectedDiscipline;
  DateTime? _dueDate;
  ActivityStatus? _selectedStatus;

  String? _selectedCategory = "Estudo";
  final _categories = <String>["Estudo", "Leitura", "Projeto", "Prova"];

  final _selectedTags = <String>[];
  final _availableTags = <String>["Urgente", "Teórica", "Prática", "Grupo"];

  bool _isLoading = false;

  void _unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  bool _hasChanges() {
    if (_initialActivity == null) return true;

    final currentDescription = jsonEncode(
      _descriptionController.document.toDelta().toJson(),
    );
    final initialDescription = _initialActivity!.description;

    final hasTitleChanged = _titleController.text != _initialActivity!.title;
    final hasDescriptionChanged = currentDescription != initialDescription;
    final hasNotesChanged =
        _notesController.text != (_initialActivity!.notes ?? "");
    final hasDisciplineChanged =
        _selectedDiscipline?.id != _initialActivity!.disciplineId;
    final hasDueDateChanged = _dueDate != _initialActivity!.dueDate;
    final hasStatusChanged = _selectedStatus != _initialActivity!.status;
    final hasCategoryChanged = _selectedCategory != _initialActivity!.category;
    final hasTagsChanged =
        !(_selectedTags.length == _initialActivity!.tags.length &&
            _selectedTags.every((t) => _initialActivity!.tags.contains(t)));
    final hasRemindersChanged =
        !(_reminders.length == _initialActivity!.reminders.length &&
            _reminders.every((r) => _initialActivity!.reminders.contains(r)));

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
      builder: (context) => CreateCategoryDialogWidget(
        onCategoryAdded: (categoryName) {
          setState(() {
            _categories.add(categoryName);
            _selectedCategory = categoryName;
          });
        },
      ),
    );
  }

  void _showCreateTagDialog() {
    _unfocus();

    showDialog(
      context: context,
      builder: (context) => CreateTagDialogWidget(
        onTagAdded: (tagName) {
          setState(() {
            _availableTags.add(tagName);
            _selectedTags.add(tagName);
          });
        },
      ),
    );
  }

  Future<void> _selectDate() async {
    _unfocus();

    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2030),
    );

    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _addReminder() async {
    _unfocus();

    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 30),
    );

    if (picked != null && !_reminders.contains(picked)) {
      setState(() => _reminders.add(picked));
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
          title: _titleController.text,
          description: description,
          notes: _notesController.text,
          disciplineId: _selectedDiscipline?.id,
          dueDate: _dueDate,
          category: _selectedCategory,
          tags: _selectedTags,
          reminders: _reminders,
          status: _selectedStatus,
        );
        result = await _activityController.editActivity(updatedActivity);
      } else {
        result = await _activityController.createActivity(
          title: _titleController.text,
          description: description,
          notes: _notesController.text,
          disciplineId: _selectedDiscipline!.id,
          dueDate: _dueDate,
          category: _selectedCategory,
          tags: _selectedTags,
          reminders: _reminders,
          status: _selectedStatus,
        );
      }

      result.fold(
        onSuccess: (_) {
          Navigator.pop(context, true);
        },
        onFailure: (f) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro ao salvar: ${f.toString()}")),
          );
        },
      );
    }
  }

  Future<void> _loadActivity() async {
    if (widget.activityId == null) {
      if (widget.initialDisciplineId != null) {
        setState(() {
          _selectedDiscipline = adsDisciplines
              .where((d) => d.id == widget.initialDisciplineId)
              .firstOrNull;
        });
      }

      return;
    }

    setState(() => _isLoading = true);

    final result = await _activityController.getActivityById(
      widget.activityId!,
    );

    result.fold(
      onSuccess: (activity) {
        if (activity != null) {
          setState(() {
            _initialActivity = activity;
            _titleController.text = activity.title;
            _notesController.text = activity.notes ?? "";

            try {
              final doc = Document.fromJson(jsonDecode(activity.description));
              _descriptionController = QuillController(
                document: doc,
                selection: const TextSelection.collapsed(offset: 0),
              );
            } catch (err, stackTrace) {
              _logger.e(
                'Failed to parse activity description into QuillDocument',
                error: err,
                stackTrace: stackTrace,
              );

              _descriptionController = QuillController.basic();
            }

            _selectedDiscipline = adsDisciplines
                .where((d) => d.id == activity.disciplineId)
                .firstOrNull;
            _dueDate = activity.dueDate;
            _selectedStatus = activity.status;
            _selectedCategory = activity.category;
            _selectedTags.addAll(activity.tags);
            _reminders.addAll(activity.reminders);

            for (final tag in activity.tags) {
              if (!_availableTags.contains(tag)) _availableTags.add(tag);
            }

            if (activity.category != null &&
                !_categories.contains(activity.category)) {
              _categories.add(activity.category!);
            }
          });
        }
      },
      onFailure: (failure) {
        Fluttertoast.showToast(msg: 'Erro ao carregar atividade');
      },
    );

    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    _descriptionController = QuillController.basic();

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadActivity());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.activityId != null;
    final canSave = !isEditing || _hasChanges();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: isEditing ? "Editar Atividade" : "Criar Atividade",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.check_rounded,
            onPressed: canSave ? _saveTask : null,
            style: IconButtonStyle.primary,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 120.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const ActivityFormSectionTitleWidget(
                      title: "Conteúdo",
                      padding: EdgeInsets.only(bottom: 16.0),
                    ),
                    ActivityFormInputFieldWidget(
                      controller: _titleController,
                      label: "Título",
                      hint: "O que deve ser feito?",
                      isRequired: true,
                      validator: (validator) {
                        return AppValidators.required(
                          validator,
                          message: "O título é obrigatório",
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ActivityFormDescriptionFieldWidget(
                      controller: _descriptionController,
                    ),
                    const ActivityFormSectionTitleWidget(
                      title: "Classificação",
                    ),
                    ActivityFormDisciplinePickerWidget(
                      selectedDiscipline: _selectedDiscipline,
                      isRequired: true,
                      onSelected: (discipline) {
                        setState(() {
                          _selectedDiscipline = discipline;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ActivityFormStatusSelectorWidget(
                      selectedStatus: _selectedStatus,
                      onSelect: (status) {
                        setState(() => _selectedStatus = status);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ActivityFormCategorySelectorWidget(
                      categories: _categories,
                      selectedCategory: _selectedCategory,
                      isRequired: true,
                      onSelect: (category) {
                        setState(() => _selectedCategory = category);
                      },
                      onCreate: _showCreateCategoryDialog,
                    ),
                    const SizedBox(height: 20.0),
                    ActivityFormTagSelectorWidget(
                      availableTags: _availableTags,
                      selectedTags: _selectedTags,
                      onToggle: (tag, value) {
                        setState(() {
                          value
                              ? _selectedTags.add(tag)
                              : _selectedTags.remove(tag);
                        });
                      },
                      onCreate: _showCreateTagDialog,
                    ),
                    const ActivityFormSectionTitleWidget(
                      title: "Prazos e Lembretes",
                    ),
                    ActivityFormDatePickerWidget(
                      dueDate: _dueDate,
                      isRequired: false,
                      onTap: _selectDate,
                      onClear: () {
                        setState(() => _dueDate = null);
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ActivityFormRemindersWidget(
                      reminders: _reminders,
                      onAdd: _addReminder,
                      onRemove: (time) {
                        setState(() {
                          _reminders.remove(time);
                        });
                      },
                    ),
                    const ActivityFormSectionTitleWidget(title: "Anotações"),
                    InputWidget(
                      controller: _notesController,
                      hint: "Rascunhos ou lembretes rápidos...",
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ActivityFormLabelWidget extends StatelessWidget {
  final String label;
  final bool isRequired;
  final double fontSize;

  const ActivityFormLabelWidget({
    super.key,
    required this.label,
    this.isRequired = false,
    this.fontSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label,
        style: GoogleFonts.plusJakartaSans(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
        children: <TextSpan>[
          if (isRequired)
            TextSpan(
              text: ' *',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.red,
                fontWeight: FontWeight.w900,
              ),
            ),
        ],
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
        ActivityFormLabelWidget(label: label, isRequired: isRequired),
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
  final ActivityStatus? selectedStatus;
  final void Function(ActivityStatus? value) onSelect;

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
        const ActivityFormLabelWidget(label: "Status"),
        const SizedBox(height: 12.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8.0,
            children: ActivityStatus.values.builder((status, index) {
              final isSelected = selectedStatus == status;

              return SelectableChipWidget(
                onTap: () => onSelect(isSelected ? null : status),
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
            ActivityFormLabelWidget(label: "Categoria"),
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
