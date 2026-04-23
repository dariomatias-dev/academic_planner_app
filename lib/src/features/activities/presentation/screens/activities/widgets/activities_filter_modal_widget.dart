import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/discipline_list_modal_widget.dart';
import 'package:academic_planner/src/shared/widgets/modal_bottom_sheet_widget.dart';

class ActivitiesFilterModalWidget extends ConsumerStatefulWidget {
  const ActivitiesFilterModalWidget({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ActivitiesFilterModalWidget(),
    );
  }

  @override
  ConsumerState<ActivitiesFilterModalWidget> createState() =>
      _ActivitiesFilterModalWidgetState();
}

class _ActivitiesFilterModalWidgetState
    extends ConsumerState<ActivitiesFilterModalWidget> {
  late int? _selectedDisciplineId;
  late DateTime? _startDate;
  late DateTime? _endDate;

  void _clearFilters() {
    ref.read(activityFilterNotifierProvider.notifier).clear();

    Navigator.pop(context);
  }

  void _applyFilters() {
    ref
        .read(activityFilterNotifierProvider.notifier)
        .update(
          disciplineId: _selectedDisciplineId,
          startDate: _startDate,
          endDate: _endDate,
        );

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    final currentFilter = ref.read(activityFilterNotifierProvider);
    _selectedDisciplineId = currentFilter.disciplineId;
    _startDate = currentFilter.startDate;
    _endDate = currentFilter.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedDiscipline = _selectedDisciplineId == null
        ? null
        : adsDisciplines.firstWhere((d) => d.id == _selectedDisciplineId);

    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 32.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              width: 48.0,
              height: 5.0,
              margin: const EdgeInsets.only(bottom: 24.0),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withAlpha(20),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Filtros',
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.onSurface,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              GestureDetector(
                onTap: _clearFilters,
                child: Text(
                  'Limpar',
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.primary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          _FilterSection(
            title: 'DISCIPLINA',
            child: GestureDetector(
              onTap: () {
                ModalBottomSheetWidget.show(
                  context: context,
                  title: "Filtrar por Disciplina",
                  child: DisciplineListModalWidget(
                    selectedId: _selectedDisciplineId,
                    disciplines: adsDisciplines,
                    emptyTitle: 'Nenhuma disciplina disponível',
                    emptyDescription:
                        'Não há disciplinas cadastradas para filtragem.',
                    onSelected: (discipline) {
                      setState(() {
                        _selectedDisciplineId = discipline.id;
                      });
                    },
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: theme.dividerTheme.color ?? AppColors.transparent,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(15),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: Icon(
                        Icons.collections_bookmark_rounded,
                        color: colorScheme.primary,
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            selectedDiscipline?.name ?? "Nenhuma disciplina",
                            style: GoogleFonts.plusJakartaSans(
                              color: selectedDiscipline == null
                                  ? colorScheme.onSurface.withAlpha(120)
                                  : colorScheme.onSurface,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            selectedDiscipline == null
                                ? "Toque para selecionar"
                                : "Filtro ativo",
                            style: GoogleFonts.plusJakartaSans(
                              color: colorScheme.onSurface.withAlpha(100),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.unfold_more_rounded,
                      color: colorScheme.onSurface.withAlpha(60),
                      size: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          _FilterSection(
            title: 'PERÍODO',
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _DateTile(
                    label: 'Início',
                    date: _startDate,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (date != null) setState(() => _startDate = date);
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _DateTile(
                    label: 'Fim',
                    date: _endDate,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? _startDate ?? DateTime.now(),
                        firstDate: _startDate ?? DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (date != null) setState(() => _endDate = date);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48.0),
          ButtonWidget(
            onPressed: _applyFilters,
            label: 'Aplicar Filtros',
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 11.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16.0),
        child,
      ],
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DateTile({required this.label, this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withAlpha(10),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface.withAlpha(100),
                fontSize: 10.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              date != null
                  ? DateFormat('dd/MM/yyyy').format(date!)
                  : '--/--/--',
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface,
                fontSize: 14.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
