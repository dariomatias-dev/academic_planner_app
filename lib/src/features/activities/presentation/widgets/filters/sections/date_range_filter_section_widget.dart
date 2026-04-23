import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateRangeFilterSectionWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime? date) onStartDateChanged;
  final Function(DateTime? date) onEndDateChanged;

  const DateRangeFilterSectionWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'PERÍODO',
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.primary,
            fontSize: 11.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          children: <Widget>[
            Expanded(
              child: _DateTile(
                label: 'Início',
                date: startDate,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (date != null) onStartDateChanged(date);
                },
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: _DateTile(
                label: 'Fim',
                date: endDate,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? startDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (date != null) onEndDateChanged(date);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DateTile({required this.label, this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withAlpha(10),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface.withAlpha(100),
                fontSize: 10.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              date != null
                  ? DateFormat('dd/MM/yyyy').format(date!)
                  : '--/--/--',
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface,
                fontSize: 14.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
