import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MetricCardWidget extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;
  final IconData icon;
  final Color color;

  const MetricCardWidget({
    super.key,
    required this.label,
    this.value,
    this.valueWidget,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color:
              theme.dividerTheme.color ??
              colorScheme.outlineVariant.withAlpha(50),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20.0),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                valueWidget ??
                    Text(
                      value ?? "0",
                      style: GoogleFonts.plusJakartaSans(
                        color: theme.colorScheme.onSurface,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                Text(
                  label,
                  style: TextStyle(
                    color: colorScheme.onSurface.withAlpha(140),
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
