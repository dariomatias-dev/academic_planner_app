import 'package:academic_planner/src/shared/widgets/nav_bar/nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootNavigation extends StatefulWidget {
  const RootNavigation({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<RootNavigation> createState() => _RootNavigationState();
}

class _RootNavigationState extends State<RootNavigation> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
  }

  @override
  void didUpdateWidget(RootNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);

    _animateToCurrentPage();
  }

  void _animateToCurrentPage() {
    final newIndex = widget.navigationShell.currentIndex;
    if (_pageController.hasClients &&
        _pageController.page?.round() != newIndex) {
      _pageController
          .animateToPage(
            newIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
          .ignore();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              if (index != widget.navigationShell.currentIndex) {
                widget.navigationShell.goBranch(index);
              }
            },
            children: widget.children,
          ),
          NavBarWidget(
            selectedIndex: widget.navigationShell.currentIndex,
            onTap: (index) {
              widget.navigationShell.goBranch(
                index,
                initialLocation: index == widget.navigationShell.currentIndex,
              );
            },
          ),
        ],
      ),
    );
  }
}
