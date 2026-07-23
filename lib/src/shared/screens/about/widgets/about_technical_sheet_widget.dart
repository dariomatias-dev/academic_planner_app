import 'package:academic_planner/src/core/di/app_version_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutTechnicalSheetWidget extends StatelessWidget {
  const AboutTechnicalSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final appVersion = ref.watch(appVersionProvider);

              return _InfoRowWidget(
                label: 'Versão Instalada',
                value: appVersion.maybeWhen(
                  data: (version) => version,
                  orElse: () => '•.•.•',
                ),
                isLast: false,
              );
            },
          ),
          const _InfoRowWidget(
            label: 'Plataforma Principal',
            value: 'Android OS',
            isLast: false,
          ),
          const _InfoRowWidget(
            label: 'Tecnologia Base',
            value: 'Flutter',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _InfoRowWidget extends StatelessWidget {
  const _InfoRowWidget({
    required this.label,
    required this.value,
    required this.isLast,
  });

  final String label;
  final String value;
  final bool isLast;

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
  }) {
    return GoogleFonts.plusJakartaSans(
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontSize: size,
      fontWeight: weight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: theme.dividerTheme.color ?? Colors.transparent,
                ),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: _textStyle(
              context,
              color: colorScheme.onSurface.withAlpha(160),
              size: 13.0,
              weight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: _textStyle(context, size: 13.0, weight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
