import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines.dart';

import 'package:academic_planner/src/screens/disciplines/widgets/discipline_card_widget.dart';

class DisciplinesScreen extends StatelessWidget {
  const DisciplinesScreen({super.key});

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
                "Minha Grade",
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
                return DisciplineCardWidget(discipline: disciplines[index]);
              }, childCount: disciplines.length),
            ),
          ),
        ],
      ),
    );
  }
}
