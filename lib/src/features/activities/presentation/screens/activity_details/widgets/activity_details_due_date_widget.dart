import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ActivityDetailsDueDateWidget extends StatelessWidget {
  final DateTime? dueDate;

  const ActivityDetailsDueDateWidget({super.key, this.dueDate});

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
          color: theme.dividerTheme.color ?? Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            color: colorScheme.primary,
            size: 20.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "PRAZO DE ENTREGA",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface.withAlpha(120),
                  ),
                ),
                Text(
                  dueDate != null
                      ? DateFormat(
                          "dd 'de' MMMM, yyyy",
                          "pt_BR",
                        ).format(dueDate!)
                      : "Sem data definida",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
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
