import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/discipline_card/discipline_card_item_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';

const studentEnrolledIds = <int>{51, 52, 53, 54, 55};

class MyDisciplinesScreen extends StatelessWidget {
  const MyDisciplinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enrolledDisciplines = adsDisciplines.filter(
      (discipline) => studentEnrolledIds.contains(discipline.id),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "Minha Grade",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.account_tree_rounded,
            onPressed: () {
              AppRoutes.goToMySchedule(context);
            },
            style: IconButtonStyle.primary,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRoutes.goToDisciplineSelection(context);
        },
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Icon(
          Icons.calendar_today_rounded,
          color: colorScheme.onPrimary,
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
