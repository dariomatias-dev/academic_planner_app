import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutMetricBadgesWidget extends StatelessWidget {
  const AboutMetricBadgesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _ImpactBadgeWidget(
          label: 'Foco',
          icon: Icons.center_focus_strong_rounded,
        ),
        SizedBox(width: 12.0),
        _ImpactBadgeWidget(
          label: 'Gestão',
          icon: Icons.auto_graph_rounded,
        ),
        SizedBox(width: 12.0),
        _ImpactBadgeWidget(
          label: 'Eficaz',
          icon: Icons.bolt_rounded,
        ),
      ],
    );
  }
}

class _ImpactBadgeWidget extends StatelessWidget {
  const _ImpactBadgeWidget({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

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
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          children: [
            Icon(icon, color: colorScheme.primary, size: 28.0),
            const SizedBox(height: 12.0),
            Text(
              label,
              style: _textStyle(
                context,
                color: colorScheme.primary,
                weight: FontWeight.w800,
                size: 13.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
