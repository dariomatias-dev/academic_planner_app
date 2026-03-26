import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class CreateTaskReminderWidget extends StatelessWidget {
  final TimeOfDay time;
  final VoidCallback onRemove;

  const CreateTaskReminderWidget({
    super.key,
    required this.time,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.access_time_rounded,
            color: AppColors.primary,
            size: 16.0,
          ),
          const SizedBox(width: 8.0),
          Text(
            time.format(context),
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMain,
              fontSize: 13.0,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8.0),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              color: AppColors.textSub.withAlpha(150),
              size: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
