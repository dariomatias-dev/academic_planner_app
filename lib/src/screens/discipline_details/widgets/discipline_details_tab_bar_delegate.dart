import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class DisciplineDetailsTabBarDelegate extends SliverPersistentHeaderDelegate {
  DisciplineDetailsTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppColors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(DisciplineDetailsTabBarDelegate oldDelegate) {
    return false;
  }
}
