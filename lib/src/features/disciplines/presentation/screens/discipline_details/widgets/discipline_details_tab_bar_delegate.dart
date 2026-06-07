import 'package:flutter/material.dart';

class DisciplineDetailsTabBarDelegate extends SliverPersistentHeaderDelegate {
  DisciplineDetailsTabBarDelegate(this.tabBar);

  final PreferredSizeWidget tabBar;

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
    return Container(
      color: Theme.of(context).colorScheme.surface,
      height: tabBar.preferredSize.height,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant DisciplineDetailsTabBarDelegate oldDelegate) {
    return oldDelegate.tabBar != tabBar;
  }
}
