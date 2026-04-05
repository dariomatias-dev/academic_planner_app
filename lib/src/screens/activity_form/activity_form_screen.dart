import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/app_validators.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/constants/mock_activities.dart';
import 'package:academic_planner/src/core/extensions/activity_status_extension.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/screens/activity_form/widgets/activity_form_description_field/activity_form_description_field_widget.dart';
import 'package:academic_planner/src/screens/activity_form/widgets/activity_form_discipline_picker/activity_form_discipline_picker_widget.dart';
import 'package:academic_planner/src/screens/activity_form/widgets/activity_form_section_title_widget.dart';
import 'package:academic_planner/src/screens/activity_form/widgets/activity_reminders/activity_reminder_widget.dart';
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
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final QuillController _descriptionController;
  late final TextEditingController _notesController;
  final _reminders = <TimeOfDay>[];

  DisciplineModel? _selectedDiscipline;
  DateTime? _dueDate;
  ActivityStatus? _selectedStatus;

  String? _selectedCategory = "Estudo";
  final _categories = <String>["Estudo", "Leitura", "Projeto", "Prova"];

  final _selectedTags = <String>[];
  final _availableTags = <String>["Urgente", "Teórica", "Prática", "Grupo"];

  void _unfocus() => FocusManager.instance.primaryFocus?.unfocus();

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

  void _saveTask() {
    _unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();

    final activity = mockActivities
        .where((activity) => activity.id == widget.activityId)
        .firstOrNull;

    _titleController = TextEditingController(text: activity?.title);
    _notesController = TextEditingController(text: activity?.notes);

    if (activity != null && activity.description.isNotEmpty) {
      try {
        final doc = Document.fromJson(jsonDecode(activity.description));
        _descriptionController = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        _descriptionController = QuillController.basic();
      }
    } else {
      _descriptionController = QuillController.basic();
    }

    if (activity != null) {
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
    } else if (widget.initialDisciplineId != null) {
      _selectedDiscipline = adsDisciplines
          .where((d) => d.id == widget.initialDisciplineId)
          .firstOrNull;
    }
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: isEditing ? "Editar Atividade" : "Criar Atividade",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.check_rounded,
            onPressed: _saveTask,
            style: IconButtonStyle.primary,
          ),
        ],
      ),
      body: SingleChildScrollView(
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
              const ActivityFormSectionTitleWidget(title: "Classificação"),
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
                    value ? _selectedTags.add(tag) : _selectedTags.remove(tag);
                  });
                },
                onCreate: _showCreateTagDialog,
              ),
              const ActivityFormSectionTitleWidget(title: "Prazos e Lembretes"),
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

class ActivityFormDatePickerWidget extends StatelessWidget {
  final DateTime? dueDate;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final bool isRequired;

  const ActivityFormDatePickerWidget({
    super.key,
    this.dueDate,
    required this.onTap,
    required this.onClear,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color:
                Theme.of(context).dividerTheme.color ?? AppColors.transparent,
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                color: colorScheme.primary,
                size: 24.0,
              ),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ActivityFormLabelWidget(
                  label: "Data de Entrega",
                  isRequired: isRequired,
                  fontSize: 11.0,
                ),
                Text(
                  dueDate == null
                      ? "Definir prazo"
                      : DateFormat('dd / MM / yyyy').format(dueDate!),
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.onSurface,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (dueDate != null) ...<Widget>[
              GestureDetector(
                onTap: (onClear),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: colorScheme.error,
                    size: 22.0,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
            ],
            const SizedBox(width: 4.0),
            Icon(
              Icons.edit_calendar_rounded,
              color: colorScheme.primary,
              size: 22.0,
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityFormRemindersWidget extends StatelessWidget {
  final List<TimeOfDay> reminders;
  final VoidCallback onAdd;
  final Function(TimeOfDay) onRemove;

  const ActivityFormRemindersWidget({
    super.key,
    required this.reminders,
    required this.onAdd,
    required this.onRemove,
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
              "Lembretes",
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: onAdd,
              child: Text(
                "+ Novo Horário",
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.primary,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        if (reminders.isEmpty)
          Text(
            "Nenhum lembrete definido.",
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface.withAlpha(160),
              fontSize: 12.0,
            ),
          )
        else
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: reminders.builder((time, index) {
              return ActivityReminderWidget(
                time: time,
                onRemove: () => onRemove(time),
              );
            }),
          ),
      ],
    );
  }
}
