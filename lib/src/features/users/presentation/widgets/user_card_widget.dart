import 'package:academic_planner/src/core/extensions/user_role_extension.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserCardWidget extends StatelessWidget {
  const UserCardWidget({required this.user, super.key});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final roleColor = user.role.getColor(colorScheme);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withAlpha(10),
            blurRadius: 24.0,
            offset: const Offset(0.0, 8.0),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: roleColor.withAlpha(20),
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Icon(user.role.icon, color: roleColor, size: 26.0),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 3.0,
                      ),
                      decoration: BoxDecoration(
                        color: roleColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Text(
                        user.role.label.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          color: roleColor,
                          fontSize: 9.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time_rounded,
                      size: 12.0,
                      color: colorScheme.onSurface.withAlpha(100),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      DateFormat('dd/MM/yy').format(user.createdAt),
                      style: GoogleFonts.plusJakartaSans(
                        color: colorScheme.onSurface.withAlpha(120),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.onSurface.withAlpha(140),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurface.withAlpha(60),
          ),
        ],
      ),
    );
  }
}
