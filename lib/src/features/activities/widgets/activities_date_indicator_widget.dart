import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/shared/utils/date_utils_helper.dart';

class ActivitiesDateIndicatorWidget extends StatelessWidget {
  const ActivitiesDateIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formattedDate = DateUtilsHelper.formatWeekdayDate(DateTime.now());

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              size: 14.0,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            formattedDate,
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface.withAlpha(180),
              fontSize: 13.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
