import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/shared/widgets/periods_tab_bar/period_tab_item_widget.dart';

class PeriodsTabBarWidget extends StatelessWidget {
  const PeriodsTabBarWidget({
    super.key,
    required this.controller,
    required this.periods,
  });

  final TabController controller;
  final List<int> periods;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: AppColors.transparent,
        indicatorColor: AppColors.transparent,
        overlayColor: WidgetStateProperty.all(AppColors.transparent),
        splashFactory: NoSplash.splashFactory,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        tabs: List.generate(periods.length, (index) {
          final period = periods[index];

          return Tab(
            child: PeriodTabItemWidget(
              period: period,
              isSelected: controller.index == index,
            ),
          );
        }),
      ),
    );
  }
}
