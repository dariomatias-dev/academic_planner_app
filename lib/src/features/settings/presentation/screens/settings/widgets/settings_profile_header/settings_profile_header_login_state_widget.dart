import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsProfileHeaderLoginStateWidget extends StatelessWidget {
  const SettingsProfileHeaderLoginStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => AppRoutes.goToLogin(context),
      borderRadius: BorderRadius.circular(32.0),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Row(
          children: [
            Container(
              width: 72.0,
              height: 72.0,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Icon(
                Icons.account_circle_outlined,
                color: colorScheme.primary,
                size: 32.0,
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Entre na sua conta',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Acesse seus dados acadêmicos',
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onSurface.withAlpha(140),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.0,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
