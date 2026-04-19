import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/shared/widgets/forms/forms.dart';

class ActivityFormDatePickerWidget extends StatelessWidget {
  final DateTime? dueDate;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final bool isRequired;

  const ActivityFormDatePickerWidget({
    super.key,
    this.dueDate,
    required this.onTap,
    required this.onClear,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color:
                Theme.of(context).dividerTheme.color ?? AppColors.transparent,
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                color: colorScheme.primary,
                size: 24.0,
              ),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FormFieldLabelWidget(
                  label: "Data de Entrega",
                  isRequired: isRequired,
                  fontSize: 11.0,
                ),
                Text(
                  dueDate == null
                      ? "Definir prazo"
                      : DateFormat('dd / MM / yyyy').format(dueDate!),
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.onSurface,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (dueDate != null) ...<Widget>[
              GestureDetector(
                onTap: (onClear),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: colorScheme.error,
                    size: 22.0,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
            ],
            const SizedBox(width: 4.0),
            Icon(
              Icons.edit_calendar_rounded,
              color: colorScheme.primary,
              size: 22.0,
            ),
          ],
        ),
      ),
    );
  }
}
