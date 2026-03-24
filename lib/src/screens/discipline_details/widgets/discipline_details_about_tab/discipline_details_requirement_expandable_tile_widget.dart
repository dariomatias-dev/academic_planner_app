import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';
import 'package:academic_planner/src/shared/widgets/discipline_card/discipline_card_widget.dart';

class DisciplineDetailsRequirementExpandableTileWidget extends StatefulWidget {
  const DisciplineDetailsRequirementExpandableTileWidget({
    super.key,
    required this.label,
    required this.linkedDisciplines,
    required this.color,
  });

  final String label;
  final List<DisciplineModel> linkedDisciplines;
  final Color color;

  @override
  State<DisciplineDetailsRequirementExpandableTileWidget> createState() =>
      _DisciplineDetailsRequirementExpandableTileWidgetState();
}

class _DisciplineDetailsRequirementExpandableTileWidgetState
    extends State<DisciplineDetailsRequirementExpandableTileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final animation = CurvedAnimation(
    parent: expandController,
    curve: Curves.easeInOut,
  );

  bool isExpanded = false;

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        expandController.forward();
      } else {
        expandController.reverse();
      }
    });
  }

  @override
  void dispose() {
    expandController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasDisciplines = widget.linkedDisciplines.isNotEmpty;

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: AppColors.bg.withAlpha(100),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: hasDisciplines ? toggleExpansion : null,
              borderRadius: BorderRadius.circular(20.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                        color: AppColors.textMain,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: widget.color.withAlpha(20),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "${widget.linkedDisciplines.length} Disciplinas",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 11.0,
                              color: widget.color,
                            ),
                          ),
                        ),
                        if (hasDisciplines) ...<Widget>[
                          const SizedBox(width: 8.0),
                          RotationTransition(
                            turns: Tween<double>(
                              begin: 0.0,
                              end: 0.25,
                            ).animate(animation),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              size: 20.0,
                              color: widget.color,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: animation,
          axisAlignment: 1.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: widget.linkedDisciplines.builder((discipline, index) {
                return DisciplineCardWidget(
                  index: index + 1,
                  discipline: discipline,
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
