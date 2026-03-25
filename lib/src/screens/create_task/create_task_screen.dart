import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';
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

    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => DialogWidget(
        title: "Nova Categoria",
        message: "Defina um novo grupo para suas atividades.",
        icon: Icons.grid_view_rounded,
        actions: Column(
          children: <Widget>[
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Nome da categoria",
                filled: true,
                fillColor: AppColors.bg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: ButtonWidget(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyles.neutral,
                    label: 'Cancelar',
                    isFullWidth: true,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ButtonWidget(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        setState(() {
                          _categories.add(controller.text);
                          _selectedCategory = controller.text;
                        });
                        Navigator.pop(context);
                      }
                    },
                    label: "Adicionar",
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTagDialog() {
    _unfocus();

    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => DialogWidget(
        title: "Nova Tag",
        message: "Crie uma etiqueta personalizada.",
        icon: Icons.style_rounded,
        actions: Column(
          children: <Widget>[
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Nome da tag",
                filled: true,
                fillColor: AppColors.bg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: ButtonWidget(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyles.neutral,
                    label: 'Cancelar',
                    isFullWidth: true,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ButtonWidget(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        setState(() {
                          _availableTags.add(controller.text);
                          _selectedTags.add(controller.text);
                        });

                        Navigator.pop(context);
                      }
                    },
                    label: "Salvar",
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
          ],
        ),
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
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[SliverToBoxAdapter(child: _buildHeader())];
            },
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildSectionTitle("Conteúdo"),
                  _buildTextField(
                    controller: _titleController,
                    label: "Título da Tarefa",
                    hint: "O que deve ser feito?",
                  ),
                  _buildTextField(
                    controller: _descriptionController,
                    label: "Descrição",
                    hint: "Mais detalhes...",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32.0),
                  _buildSectionTitle("Classificação"),
                  _buildDisciplinePicker(),
                  const SizedBox(height: 20.0),
                  _buildCategorySelector(),
                  const SizedBox(height: 20.0),
                  _buildTagSelector(),
                  const SizedBox(height: 32.0),
                  _buildSectionTitle("Prioridade"),
                  _buildPriorityPicker(),
                  const SizedBox(height: 32.0),
                  _buildSectionTitle("Prazos e Lembretes"),
                  _buildDatePicker(),
                  const SizedBox(height: 16.0),
                  _buildRemindersList(),
                  const SizedBox(height: 32.0),
                  _buildSectionTitle("Anotações e Links"),
                  _buildTextField(
                    controller: _notesController,
                    label: "Notas",
                    hint: "Rascunhos ou lembretes rápidos...",
                    maxLines: 5,
                  ),
                  _buildLinkInput(),
                  const SizedBox(height: 40.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                onPressed: () => Navigator.pop(context),
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
                icon: Icons.check_rounded,
                onPressed: () {},
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

  Widget _buildSectionTitle(String title) {
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
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

  Widget _buildDisciplinePicker() {
    final enrolled = adsDisciplines.filter(
      (d) => studentEnrolledIds.contains(d.id),
    );

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
          onTap: () {
            _unfocus();

            ModalBottomSheetWidget.show(
              context: context,
              title: "Minhas Matérias",
              child: _buildDisciplineList(enrolled),
            );
          },
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
                    _selectedDiscipline?.name ?? "Selecione uma matéria",
                    style: GoogleFonts.plusJakartaSans(
                      color: _selectedDiscipline == null
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

  Widget _buildDisciplineList(List<DisciplineModel> disciplines) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: disciplines.length,
      itemBuilder: (context, index) {
        final discipline = disciplines[index];
        final isSelected = _selectedDiscipline?.id == discipline.id;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 12.0,
          ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          tileColor: isSelected ? AppColors.primary.withAlpha(10) : null,
          onTap: () {
            setState(() {
              _selectedDiscipline = discipline;
            });

            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _buildCategorySelector() {
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
              onTap: _showCreateCategoryDialog,
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
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
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
                      cat,
                      style: GoogleFonts.plusJakartaSans(
                        color: isSelected ? AppColors.white : AppColors.textSub,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTagSelector() {
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
              onTap: _showCreateTagDialog,
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
          children: _availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedTags.add(tag);
                  } else {
                    _selectedTags.remove(tag);
                  }
                });
              },
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
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriorityPicker() {
    return Row(
      children: TaskPriority.values.map((priority) {
        final isSelected = _selectedPriority == priority;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedPriority = priority),
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
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _selectDate,
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
                  _dueDate == null
                      ? "Definir prazo"
                      : DateFormat('dd / MM / yyyy').format(_dueDate!),
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

  Widget _buildRemindersList() {
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
              onTap: _addReminder,
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
        if (_reminders.isEmpty)
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
            children: _reminders.map((time) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.black.withAlpha(5),
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 4.0),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.access_time_rounded,
                      size: 16.0,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      time.format(context),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () => setState(() => _reminders.remove(time)),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16.0,
                        color: AppColors.textSub.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildLinkInput() {
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
                controller: _linkController,
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
              onPressed: _addLink,
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
        if (_links.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: _links
                  .map(
                    (link) => Container(
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
                            size: 18.0,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Text(
                              link,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMain,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          GestureDetector(
                            onTap: () => setState(() => _links.remove(link)),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              size: 20.0,
                              color: AppColors.textSub,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
