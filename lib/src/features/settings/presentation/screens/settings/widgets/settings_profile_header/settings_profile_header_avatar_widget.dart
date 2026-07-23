import 'package:academic_planner/src/core/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsProfileHeaderAvatarWidget extends StatelessWidget {
  const SettingsProfileHeaderAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 92.0,
          height: 92.0,
          decoration: BoxDecoration(
            color: colorScheme.primary.withAlpha(15),
            borderRadius: BorderRadius.circular(28.0),
            border: Border.all(
              color: colorScheme.primary.withAlpha(40),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.person_rounded,
              color: colorScheme.primary,
              size: 48.0,
            ),
          ),
        ),
        Container(
          height: 30.0,
          width: 30.0,
          decoration: BoxDecoration(
            color: AppColors.emerald500,
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.surface, width: 3.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.emerald500.withAlpha(60),
                blurRadius: 10.0,
                offset: const Offset(0.0, 4.0),
              ),
            ],
          ),
          child: const Icon(
            Icons.verified_rounded,
            size: 14.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
