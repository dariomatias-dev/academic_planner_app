import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/settings_profile_header/settings_profile_header_avatar_widget.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/settings_profile_header/settings_profile_header_badge_widget.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/settings_profile_header/settings_profile_header_institution_card_widget.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsProfileHeaderProfileStateWidget extends StatelessWidget {
  const SettingsProfileHeaderProfileStateWidget({
    required this.user,
    super.key,
  });

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Row(
            children: [
              const SettingsProfileHeaderAvatarWidget(),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SettingsProfileHeaderBadgeWidget(),
                    const SizedBox(height: 12.0),
                    Text(
                      user.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                        height: 1.1,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      user.email,
                      style: GoogleFonts.plusJakartaSans(
                        color: colorScheme.onSurface.withAlpha(140),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SettingsProfileHeaderInstitutionCardWidget(),
      ],
    );
  }
}
