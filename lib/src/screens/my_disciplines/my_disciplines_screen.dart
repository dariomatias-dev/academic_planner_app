import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/screens/discipline_selection/discipline_selection_screen.dart';
import 'package:academic_planner/src/screens/my_schedule/my_schedule_screen.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/discipline_card/discipline_card_item_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_buttons.dart';

const studentEnrolledIds = <int>{51, 52, 53, 54, 55};

class MyDisciplinesScreen extends StatelessWidget {
  const MyDisciplinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final enrolledDisciplines = adsDisciplines.filter(
      (d) => studentEnrolledIds.contains(d.id),
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBarWidget(
        title: "Minha Grade",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.account_tree_rounded,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const MyScheduleScreen();
                  },
                ),
              );
            },
            style: IconButtonStyles.primary,
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const DisciplineSelectionScreen();
              },
            ),
          );
        },
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const Icon(
          Icons.calendar_today_rounded,
          color: AppColors.white,
          size: 24.0,
        ),
      ),
      bottomNavigationBar: const SizedBox(height: 110.0),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 80.0),
        itemCount: enrolledDisciplines.length,
        itemBuilder: (context, index) {
          return DisciplineCardItemWidget(
            index: index + 1,
            discipline: enrolledDisciplines[index],
          );
        },
      ),
    );
  }
}
