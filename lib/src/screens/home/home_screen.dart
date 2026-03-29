import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/constants/mock_activities.dart';

import 'package:academic_planner/src/screens/home/widgets/home_main_focus_card_widget.dart';
import 'package:academic_planner/src/screens/home/widgets/home_quick_actions_row_widget.dart';

import 'package:academic_planner/src/shared/widgets/activity_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Olá, Estudante",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26.0,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      "Vamos organizar seus estudos?",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.0,
                        color: colorScheme.onSurface.withAlpha(160),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: colorScheme.surface,
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: HomeMainFocusCardWidget(),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
            child: HomeQuickActionsRowWidget(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          sliver: SliverToBoxAdapter(
            child: Text(
              "Próximas Entregas",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 120.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return ActivityCardWidget(activity: mockActivities[index]);
            }, childCount: mockActivities.length),
          ),
        ),
      ],
    );
  }
}
