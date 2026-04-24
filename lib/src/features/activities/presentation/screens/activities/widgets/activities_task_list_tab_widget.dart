import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';

import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';

class ActivitiesTaskListTabWidget extends StatelessWidget {
  final List<Activity> activities;
  final String description;
  final String emptyMessage;

  const ActivitiesTaskListTabWidget({
    super.key,
    required this.activities,
    required this.description,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
          child: Text(
            description.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.0,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: colorScheme.primary.withAlpha(180),
            ),
          ),
        ),
        Expanded(
          child: activities.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.inventory_2_outlined,
                  title: 'Sem atividades',
                  description: emptyMessage,
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 140.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    return ActivityCardWidget(activity: activities[index]);
                  },
                ),
        ),
      ],
    );
  }
}
