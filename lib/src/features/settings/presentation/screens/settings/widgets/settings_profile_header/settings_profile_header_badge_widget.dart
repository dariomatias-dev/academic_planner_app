import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/extensions/user_role_extension.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsProfileHeaderBadgeWidget extends ConsumerWidget {
  const SettingsProfileHeaderBadgeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).value;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.emerald500.withAlpha(15),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.emerald500.withAlpha(30)),
      ),
      child: Text(
        user?.role.label.toUpperCase() ?? 'CONTA VERIFICADA',
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.emerald500,
          fontSize: 9.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
