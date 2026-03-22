import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/mock_activities.dart';

import 'package:academic_planner/src/shared/widgets/activity_card_widget.dart';

class ActivitiesScreenWidget extends StatelessWidget {
  const ActivitiesScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 20.0),
              child: Text(
                "Tarefas",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 120.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return ActivityCardWidget(activity: mockActivities[index]);
              }, childCount: mockActivities.length),
            ),
          ),
        ],
      ),
    );
  }
}
