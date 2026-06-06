import 'package:flutter/material.dart';

class NavItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final ValueChanged<int> onTap;

  const NavItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.onSurface.withAlpha(153);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.15 : 1.0,
              child: Icon(
                icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 23.0,
              ),
            ),
            const SizedBox(height: 4.0),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 10.0,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
