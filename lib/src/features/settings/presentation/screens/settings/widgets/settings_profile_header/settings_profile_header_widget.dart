import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/settings_profile_header/settings_profile_header_login_state_widget.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/settings_profile_header/settings_profile_header_profile_state_widget.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsProfileHeaderWidget extends StatelessWidget {
  const SettingsProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(
          color: isDark
              ? theme.dividerTheme.color ?? Colors.transparent
              : colorScheme.outlineVariant.withAlpha(80),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 40.0,
            offset: const Offset(0.0, 20.0),
          ),
        ],
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final user = ref.watch(userNotifierProvider).value;

          if (user == null) {
            return const SettingsProfileHeaderLoginStateWidget();
          }

          return SettingsProfileHeaderProfileStateWidget(user: user);
        },
      ),
    );
  }
}
