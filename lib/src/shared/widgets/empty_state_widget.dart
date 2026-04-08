import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onActionPressed,
  });

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
    double? spacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontWeight: weight,
      letterSpacing: spacing,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: Icon(icon, size: 44.0, color: colorScheme.primary),
            ),
            const SizedBox(height: 32.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: _textStyle(
                context,
                size: 22.0,
                weight: FontWeight.w900,
                spacing: -0.5,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              description,
              textAlign: TextAlign.center,
              style: _textStyle(
                context,
                size: 15.0,
                color: colorScheme.onSurface.withAlpha(160),
                weight: FontWeight.w500,
                height: 1.6,
              ),
            ),
            if (actionLabel != null && onActionPressed != null) ...<Widget>[
              const SizedBox(height: 40.0),
              ButtonWidget(
                onPressed: onActionPressed!,
                label: actionLabel!,
                isFullWidth: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
