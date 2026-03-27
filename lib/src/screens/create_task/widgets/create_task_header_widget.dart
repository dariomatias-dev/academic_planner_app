import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_buttons.dart';

class CreateTaskHeaderWidget extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSave;

  const CreateTaskHeaderWidget({
    super.key,
    required this.onBack,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 32.0),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: onBack,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.bg,
                  fixedSize: const Size(48.0, 48.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.textMain,
                  size: 28.0,
                ),
              ),
              IconButtonWidget(
                onPressed: onSave,
                icon: Icons.check_rounded,
                style: IconButtonStyles.primary,
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          Text(
            "Criar Tarefa",
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMain,
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            "Adicione uma nova atividade à sua grade",
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSub,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
