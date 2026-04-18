import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/user/di/user_providers.dart';
import 'package:academic_planner/src/features/user/domain/entities/user_entity.dart';

class SettingsProfileHeaderWidget extends StatelessWidget {
  const SettingsProfileHeaderWidget({super.key});

  static const _institutionLogoUrl =
      'https://cdn.brandfetch.io/id27nEqSG5/w/300/h/331/theme/dark/logo.png';

  static const _staticCourse = "Análise e Desenvolvimento de Sistemas";
  static const _staticCampus = "Esperança";

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

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
        boxShadow: <BoxShadow>[
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
            return _buildLoginState(context);
          }

          return _buildProfileState(context, user);
        },
      ),
    );
  }

  Widget _buildProfileState(BuildContext context, UserEntity user) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Row(
            children: <Widget>[
              _buildAvatar(context),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildVerifiedBadge(context),
                    const SizedBox(height: 12.0),
                    Text(
                      user.name,
                      style: _textStyle(
                        context,
                        size: 26.0,
                        weight: FontWeight.w900,
                        letterSpacing: -1.0,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      user.email,
                      style: _textStyle(
                        context,
                        color: colorScheme.onSurface.withAlpha(140),
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildInstitutionCard(context),
      ],
    );
  }

  Widget _buildLoginState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => AppRoutes.goToLogin(context),
      borderRadius: BorderRadius.circular(32.0),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Row(
          children: <Widget>[
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
                children: <Widget>[
                  Text(
                    "Entre na sua conta",
                    style: _textStyle(
                      context,
                      size: 20.0,
                      weight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Acesse seus dados acadêmicos",
                    style: _textStyle(
                      context,
                      color: colorScheme.onSurface.withAlpha(140),
                      weight: FontWeight.w600,
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

  Widget _buildAvatar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
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
            border: Border.all(
              color: Theme.of(context).colorScheme.surface,
              width: 3.5,
            ),
            boxShadow: <BoxShadow>[
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

  Widget _buildVerifiedBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.emerald500.withAlpha(15),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.emerald500.withAlpha(30)),
      ),
      child: Text(
        "CONTA VERIFICADA",
        style: _textStyle(
          context,
          color: AppColors.emerald500,
          size: 9.0,
          weight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildInstitutionLogo(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 48.0,
      height: 48.0,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10.0),
        ],
      ),
      child: Image.network(
        _institutionLogoUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.school_rounded,
            color: AppColors.emerald500,
            size: 24.0,
          );
        },
      ),
    );
  }

  Widget _buildInstitutionCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.emerald500.withAlpha(10)
            : AppColors.emerald500.withAlpha(12),
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(
          color: isDark
              ? AppColors.emerald500.withAlpha(25)
              : AppColors.emerald500.withAlpha(20),
        ),
      ),
      child: Row(
        children: <Widget>[
          _buildInstitutionLogo(context),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _staticCourse,
                  style: _textStyle(
                    context,
                    size: 14.0,
                    weight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "IFPB Campus $_staticCampus",
                  style: _textStyle(
                    context,
                    color: AppColors.emerald600,
                    size: 12.0,
                    weight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
