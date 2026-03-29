import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/app_validators.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/screens/create_task/widgets/create_category_dialog_widget.dart';
import 'package:academic_planner/src/screens/create_task/widgets/create_tag_dialog_widget.dart';
import 'package:academic_planner/src/screens/create_task/widgets/create_task_reminders/create_task_reminder_widget.dart';
import 'package:academic_planner/src/screens/create_task/widgets/create_task_section_title_widget.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/filter_chip_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/modal_bottom_sheet_widget.dart';
import 'package:academic_planner/src/shared/widgets/selectable_chip_widget.dart';

const studentEnrolledIds = <int>{51, 52, 53, 54, 55};

class CreateTaskScreen extends StatefulWidget {
  final int? initialDisciplineId;

  const CreateTaskScreen({super.key, this.initialDisciplineId});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _linkController = TextEditingController();
  final _reminders = <TimeOfDay>[];

  DisciplineModel? _selectedDiscipline;
  DateTime? _dueDate;

  String _selectedCategory = "Estudo";
  final _categories = <String>["Estudo", "Leitura", "Projeto", "Prova"];

  final _selectedTags = <String>{};
  final _availableTags = <String>["Urgente", "Teórica", "Prática", "Grupo"];

  final _links = <String>[];

  void _unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  void _addLink() {
    if (_linkController.text.isEmpty) return;

    final validationError = AppValidators.url(_linkController.text);
    if (validationError != null) return;

    final link = _linkController.text.trim();
    if (!_links.contains(link)) {
      setState(() {
        _links.add(link);
        _linkController.clear();
      });
    }
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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
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

    if (widget.initialDisciplineId != null) {
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
    _linkController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBarWidget(
        label: 'Atividade',
        title: "Criar Tarefa",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.check_rounded,
            onPressed: _saveTask,
            style: IconButtonStyles.primary,
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
              const CreateTaskSectionTitleWidget(
                title: "Conteúdo",
                padding: EdgeInsets.only(top: 12.0, bottom: 16.0),
              ),
              CreateTaskInputFieldWidget(
                controller: _titleController,
                label: "Título da Tarefa",
                hint: "O que deve ser feito?",
                isRequired: true,
                validator: (validator) {
                  return AppValidators.required(
                    validator,
                    message: "O título é obrigatório",
                  );
                },
              ),
              CreateTaskInputFieldWidget(
                controller: _descriptionController,
                label: "Descrição",
                hint: "Mais detalhes...",
                maxLines: 3,
                isRequired: true,
                validator: (validator) {
                  return AppValidators.required(
                    validator,
                    message: "A descrição é obrigatória",
                  );
                },
              ),
              const SizedBox(height: 32.0),
              const CreateTaskSectionTitleWidget(title: "Classificação"),
              FormField<DisciplineModel>(
                initialValue: _selectedDiscipline,
                validator: (validator) {
                  return validator == null
                      ? "Selecione uma disciplina obrigatória"
                      : null;
                },
                builder: (FormFieldState<DisciplineModel> state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CreateTaskDisciplinePickerWidget(
                        selectedDiscipline: state.value,
                        isRequired: true,
                        onTap: () {
                          _unfocus();

                          ModalBottomSheetWidget.show(
                            context: context,
                            title: "Minhas Matérias",
                            child: CreateTaskDisciplineListWidget(
                              selectedId: state.value?.id,
                              onSelected: (discipline) {
                                setState(() {
                                  _selectedDiscipline = discipline;
                                });

                                state.didChange(discipline);
                              },
                            ),
                          );
                        },
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 24.0),
                          child: Text(
                            state.errorText!,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.red.shade700,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20.0),
              CreateTaskCategorySelectorWidget(
                categories: _categories,
                selectedCategory: _selectedCategory,
                isRequired: true,
                onSelect: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                onCreate: _showCreateCategoryDialog,
              ),
              const SizedBox(height: 20.0),
              CreateTaskTagSelectorWidget(
                availableTags: _availableTags,
                selectedTags: _selectedTags,
                onToggle: (tag, value) {
                  setState(() {
                    value ? _selectedTags.add(tag) : _selectedTags.remove(tag);
                  });
                },
                onCreate: _showCreateTagDialog,
              ),
              const SizedBox(height: 32.0),
              const CreateTaskSectionTitleWidget(title: "Prazos e Lembretes"),
              CreateTaskDatePickerWidget(
                dueDate: _dueDate,
                isRequired: false,
                onTap: _selectDate,
              ),
              const SizedBox(height: 16.0),
              CreateTaskRemindersWidget(
                reminders: _reminders,
                onAdd: _addReminder,
                onRemove: (time) {
                  setState(() {
                    _reminders.remove(time);
                  });
                },
              ),
              const SizedBox(height: 32.0),
              const CreateTaskSectionTitleWidget(title: "Anotações e Links"),
              CreateTaskInputFieldWidget(
                controller: _notesController,
                label: "Notas",
                hint: "Rascunhos ou lembretes rápidos...",
                maxLines: 5,
              ),
              CreateTaskLinksInputWidget(
                controller: _linkController,
                links: _links,
                onAdd: _addLink,
                onRemove: (link) {
                  setState(() {
                    _links.remove(link);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateTaskLabelWidget extends StatelessWidget {
  final String label;
  final bool isRequired;
  final double fontSize;

  const CreateTaskLabelWidget({
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
          color: AppColors.textMain,
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

class CreateTaskInputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final bool isRequired;
  final String? Function(String? value)? validator;

  const CreateTaskInputFieldWidget({
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CreateTaskLabelWidget(label: label, isRequired: isRequired),
          const SizedBox(height: 8.0),
          InputWidget(
            controller: controller,
            hint: hint,
            maxLines: maxLines,
            validator: validator,
          ),
        ],
      ),
    );
  }
}

class CreateTaskDisciplinePickerWidget extends StatelessWidget {
  final DisciplineModel? selectedDiscipline;
  final VoidCallback onTap;
  final bool isRequired;

  const CreateTaskDisciplinePickerWidget({
    super.key,
    this.selectedDiscipline,
    required this.onTap,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CreateTaskLabelWidget(label: "Disciplina", isRequired: isRequired),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.bookmark_border_rounded,
                  color: AppColors.primary,
                  size: 20.0,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    selectedDiscipline?.name ?? "Selecione uma matéria",
                    style: GoogleFonts.plusJakartaSans(
                      color: selectedDiscipline == null
                          ? AppColors.textSub
                          : AppColors.textMain,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.expand_more_rounded, color: AppColors.textSub),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CreateTaskDisciplineListWidget extends StatelessWidget {
  final int? selectedId;
  final Function(DisciplineModel value) onSelected;

  const CreateTaskDisciplineListWidget({
    super.key,
    this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final enrolled = adsDisciplines.filter((discipline) {
      return studentEnrolledIds.contains(discipline.id);
    });

    return ListView.builder(
      shrinkWrap: true,
      itemCount: enrolled.length,
      itemBuilder: (context, index) {
        final discipline = enrolled[index];
        final isSelected = selectedId == discipline.id;

        return ListTile(
          title: Text(
            discipline.name,
            style: GoogleFonts.plusJakartaSans(
              color: isSelected ? AppColors.primary : AppColors.textMain,
              fontSize: 14.0,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
          subtitle: Text(
            discipline.acronym,
            style: GoogleFonts.plusJakartaSans(fontSize: 12.0),
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
              : null,
          onTap: () {
            onSelected(discipline);

            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class CreateTaskCategorySelectorWidget extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final void Function(String value) onSelect;
  final VoidCallback onCreate;
  final bool isRequired;

  const CreateTaskCategorySelectorWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
    required this.onCreate,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CreateTaskLabelWidget(label: "Categoria", isRequired: isRequired),
            GestureDetector(
              onTap: onCreate,
              child: Text(
                "+ Nova Categoria",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.primary,
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
                onTap: () => onSelect(category),
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

class CreateTaskTagSelectorWidget extends StatelessWidget {
  final List<String> availableTags;
  final Set<String> selectedTags;
  final Function(String tag, bool value) onToggle;
  final VoidCallback onCreate;

  const CreateTaskTagSelectorWidget({
    super.key,
    required this.availableTags,
    required this.selectedTags,
    required this.onToggle,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Tags",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textMain,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: onCreate,
              child: Text(
                "+ Nova Tag",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.primary,
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

class CreateTaskDatePickerWidget extends StatelessWidget {
  final DateTime? dueDate;
  final VoidCallback onTap;
  final bool isRequired;

  const CreateTaskDatePickerWidget({
    super.key,
    this.dueDate,
    required this.onTap,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: AppColors.primary,
                size: 24.0,
              ),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CreateTaskLabelWidget(
                  label: "Data de Entrega",
                  isRequired: isRequired,
                  fontSize: 11.0,
                ),
                Text(
                  dueDate == null
                      ? "Definir prazo"
                      : DateFormat('dd / MM / yyyy').format(dueDate!),
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textMain,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.edit_calendar_rounded,
              color: AppColors.primary,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}

class CreateTaskRemindersWidget extends StatelessWidget {
  final List<TimeOfDay> reminders;
  final VoidCallback onAdd;
  final Function(TimeOfDay) onRemove;

  const CreateTaskRemindersWidget({
    super.key,
    required this.reminders,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Lembretes",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textMain,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: onAdd,
              child: Text(
                "+ Novo Horário",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.primary,
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
              color: AppColors.textSub,
              fontSize: 12.0,
            ),
          )
        else
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: reminders.builder((time, index) {
              return CreateTaskReminderWidget(
                time: time,
                onRemove: () => onRemove(time),
              );
            }),
          ),
      ],
    );
  }
}

class CreateTaskLinksInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final List<String> links;
  final VoidCallback onAdd;
  final Function(String) onRemove;

  const CreateTaskLinksInputWidget({
    super.key,
    required this.controller,
    required this.links,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const CreateTaskLabelWidget(label: "Links de Apoio"),
        const SizedBox(height: 8.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: InputWidget(
                controller: controller,
                hint: "URL do material...",
                validator: AppValidators.url,
              ),
            ),
            const SizedBox(width: 8.0),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_link_rounded, color: AppColors.white),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                fixedSize: const Size(48.0, 48.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ],
        ),
        if (links.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: links.builder((link, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.link_rounded,
                        color: AppColors.primary,
                        size: 18.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          link,
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textMain,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: () => onRemove(link),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.textSub,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
