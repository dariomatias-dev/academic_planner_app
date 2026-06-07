import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({
    required this.title,
    required this.message,
    required this.actions,
    super.key,
    this.icon,
    this.iconColor,
  });

  final String title;
  final String message;
  final Widget actions;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      backgroundColor: colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: (iconColor ?? colorScheme.primary).withAlpha(15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? colorScheme.primary,
                    size: 36.0,
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.onSurface,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.onSurface.withAlpha(160),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32.0),
              actions,
            ],
          ),
        ),
      ),
    );
  }
}
