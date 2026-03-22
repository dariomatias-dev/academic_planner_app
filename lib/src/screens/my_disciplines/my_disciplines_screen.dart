import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';

import 'package:academic_planner/src/screens/my_disciplines/widgets/discipline_card_widget.dart';

const studentEnrolledIds = {51, 52, 53, 54, 55};

class MyDisciplinesScreen extends StatelessWidget {
  const MyDisciplinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final enrolledDisciplines = adsDisciplines
        .where((d) => studentEnrolledIds.contains(d.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Minha Grade",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMain,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_tree_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 120.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return DisciplineCardWidget(
                  discipline: enrolledDisciplines[index],
                );
              }, childCount: enrolledDisciplines.length),
            ),
          ),
        ],
      ),
    );
  }
}
