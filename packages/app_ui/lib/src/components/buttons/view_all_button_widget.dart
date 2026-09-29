import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

class ViewAllButtonWidget extends StatelessWidget {
  const ViewAllButtonWidget({
    required this.label,
    required this.onTap,
    super.key,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          label,
          style: AppTypography.style(
            fontSize: 12.0,
            fontWeight: FontWeight.w800,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
