import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/screens/create_task/widgets/create_category_dialog_widget.dart';
import 'package:academic_planner/src/screens/create_task/widgets/create_tag_dialog_widget.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';
import 'package:academic_planner/src/shared/widgets/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/modal_bottom_sheet_widget.dart';

const studentEnrolledIds = <int>{51, 52, 53, 54, 55};

enum TaskPriority {
  low("Baixa"),
  medium("Média"),
  high("Alta");

  final String label;
  const TaskPriority(this.label);
}

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _linkController = TextEditingController();
  final _reminders = <TimeOfDay>[];

  DisciplineModel? _selectedDiscipline;
  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _dueDate;

  String _selectedCategory = "Estudo";
  final _categories = <String>["Estudo", "Leitura", "Projeto", "Prova"];

  final _selectedTags = <String>{};
  final _availableTags = <String>["Urgente", "Teórica", "Prática", "Grupo"];

  final _links = <String>[];

  void _unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  void _addLink() {
    final link = _linkController.text.trim();
    if (link.isNotEmpty && !_links.contains(link)) {
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
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, inner) => [
              SliverToBoxAdapter(
                child: CreateTaskHeaderWidget(
                  onBack: () => Navigator.pop(context),
                  onSave: () {},
                ),
              ),
            ],
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const CreateTaskSectionTitleWidget(title: "Conteúdo"),
                  CreateTaskInputFieldWidget(
                    controller: _titleController,
                    label: "Título da Tarefa",
                    hint: "O que deve ser feito?",
                  ),
                  CreateTaskInputFieldWidget(
                    controller: _descriptionController,
                    label: "Descrição",
                    hint: "Mais detalhes...",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32.0),
                  const CreateTaskSectionTitleWidget(title: "Classificação"),
                  CreateTaskDisciplinePickerWidget(
                    selectedDiscipline: _selectedDiscipline,
                    onTap: () {
                      _unfocus();
                      ModalBottomSheetWidget.show(
                        context: context,
                        title: "Minhas Matérias",
                        child: CreateTaskDisciplineListWidget(
                          selectedId: _selectedDiscipline?.id,
                          onSelected: (discipline) {
                            return setState(() {
                              _selectedDiscipline = discipline;
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CreateTaskCategorySelectorWidget(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onSelect: (category) {
                      return setState(() {
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
                        value
                            ? _selectedTags.add(tag)
                            : _selectedTags.remove(tag);
                      });
                    },
                    onCreate: _showCreateTagDialog,
                  ),
                  const SizedBox(height: 32.0),
                  const CreateTaskSectionTitleWidget(title: "Prioridade"),
                  CreateTaskPriorityPickerWidget(
                    selectedPriority: _selectedPriority,
                    onChanged: (priority) {
                      setState(() {
                        _selectedPriority = priority;
                      });
                    },
                  ),
                  const SizedBox(height: 32.0),
                  const CreateTaskSectionTitleWidget(
                    title: "Prazos e Lembretes",
                  ),
                  CreateTaskDatePickerWidget(
                    dueDate: _dueDate,
                    onTap: _selectDate,
                  ),
                  const SizedBox(height: 16.0),
                  CreateTaskRemindersListWidget(
                    reminders: _reminders,
                    onAdd: _addReminder,
                    onRemove: (time) {
                      setState(() {
                        _reminders.remove(time);
                      });
                    },
                  ),
                  const SizedBox(height: 32.0),
                  const CreateTaskSectionTitleWidget(
                    title: "Anotações e Links",
                  ),
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
        ),
      ),
    );
  }
}

class CreateTaskHeaderWidget extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSave;

  const CreateTaskHeaderWidget({
    super.key,
    required this.onBack,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 32.0),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: onBack,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.bg,
                  fixedSize: const Size(48.0, 48.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.textMain,
                  size: 28.0,
                ),
              ),
              IconButtonWidget(
                onPressed: onSave,
                icon: Icons.check_rounded,
                style: IconButtonStyles.primary,
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          Text(
            "Criar Tarefa",
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMain,
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            "Adicione uma nova atividade à sua grade",
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSub,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class CreateTaskSectionTitleWidget extends StatelessWidget {
  final String title;

  const CreateTaskSectionTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 24.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.primary,
          fontSize: 11.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class CreateTaskInputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;

  const CreateTaskInputFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMain,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMain,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.plusJakartaSans(
                color: AppColors.textSub.withAlpha(100),
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16.0),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateTaskDisciplinePickerWidget extends StatelessWidget {
  final DisciplineModel? selectedDiscipline;
  final VoidCallback onTap;

  const CreateTaskDisciplinePickerWidget({
    super.key,
    this.selectedDiscipline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Disciplina",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textMain,
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
        ),
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
  final Function(String value) onSelect;
  final VoidCallback onCreate;

  const CreateTaskCategorySelectorWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
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
              "Categoria",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textMain,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
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
            children: categories.builder((category, index) {
              final isSelected = selectedCategory == category;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () => onSelect(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(14.0),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.borderLight,
                      ),
                    ),
                    child: Text(
                      category,
                      style: GoogleFonts.plusJakartaSans(
                        color: isSelected ? AppColors.white : AppColors.textSub,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
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

            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (value) => onToggle(tag, value),
              backgroundColor: AppColors.white,
              selectedColor: AppColors.primary,
              checkmarkColor: AppColors.white,
              labelStyle: GoogleFonts.plusJakartaSans(
                color: isSelected ? AppColors.white : AppColors.textSub,
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide.none,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class CreateTaskPriorityPickerWidget extends StatelessWidget {
  final TaskPriority selectedPriority;
  final Function(TaskPriority value) onChanged;

  const CreateTaskPriorityPickerWidget({
    super.key,
    required this.selectedPriority,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TaskPriority.values.builder((priority, index) {
        final isSelected = selectedPriority == priority;

        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(priority),
            child: Container(
              margin: const EdgeInsets.only(right: 8.0),
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: isSelected
                    ? <BoxShadow>[
                        BoxShadow(
                          color: AppColors.primary.withAlpha(40),
                          blurRadius: 8.0,
                          offset: const Offset(0.0, 4.0),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  priority.label,
                  style: GoogleFonts.plusJakartaSans(
                    color: isSelected ? AppColors.white : AppColors.textMain,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class CreateTaskDatePickerWidget extends StatelessWidget {
  final DateTime? dueDate;
  final VoidCallback onTap;

  const CreateTaskDatePickerWidget({
    super.key,
    this.dueDate,
    required this.onTap,
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
                Text(
                  "Data de Entrega",
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textSub,
                    fontSize: 11.0,
                    fontWeight: FontWeight.w700,
                  ),
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

class CreateTaskRemindersListWidget extends StatelessWidget {
  final List<TimeOfDay> reminders;
  final VoidCallback onAdd;
  final Function(TimeOfDay) onRemove;

  const CreateTaskRemindersListWidget({
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
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.primary,
                      size: 16.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      time.format(context),
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textMain,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () => onRemove(time),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.textSub.withAlpha(150),
                        size: 16.0,
                      ),
                    ),
                  ],
                ),
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
        Text(
          "Links de Apoio",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textMain,
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "URL do material...",
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
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
