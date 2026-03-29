import 'package:flutter/material.dart';

import 'package:academic_planner/src/screens/discipline_details/discipline_details_screen.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';
import 'package:academic_planner/src/shared/widgets/discipline_card/discipline_card_widget.dart';

class DisciplineCardItemWidget extends StatelessWidget {
  const DisciplineCardItemWidget({
    super.key,
    required this.index,
    required this.discipline,
    this.initialTabIndex,
  });

  final int index;
  final DisciplineModel discipline;
  final int? initialTabIndex;

  @override
  Widget build(BuildContext context) {
    return DisciplineCardWidget(
      index: index,
      discipline: discipline,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DisciplineDetailsScreen(
                discipline: discipline,
                initialTabIndex: initialTabIndex,
              );
            },
          ),
        );
      },
    );
  }
}
