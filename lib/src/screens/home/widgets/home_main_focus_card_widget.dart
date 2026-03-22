import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/mock_activities.dart';

class HomeMainFocusCardWidget extends StatelessWidget {
  const HomeMainFocusCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withAlpha(77),
            blurRadius: 20.0,
            offset: const Offset(0.0, 12.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.auto_awesome, color: AppColors.white, size: 28.0),
          const SizedBox(height: 20.0),
          const Text(
            "Seu foco hoje",
            style: TextStyle(color: Colors.white70, fontSize: 16.0),
          ),
          const SizedBox(height: 4.0),
          Text(
            "${mockActivities.length} Atividades",
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 34.0,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Text(
              "Semana de Provas",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
