import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseDetailsMetricsCardWidget extends StatelessWidget {
  const CourseDetailsMetricsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 40.0,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(color: colorScheme.onSurface.withAlpha(10)),
      ),
      child: const IntrinsicHeight(
        child: Row(
          children: [
            _CompactMetricWidget(
              value: '3 ANOS',
              label: 'Duração',
              icon: Icons.timer_outlined,
            ),
            _VerticalDividerWidget(),
            _CompactMetricWidget(
              value: '2.084H',
              label: 'Carga',
              icon: Icons.history_edu_rounded,
            ),
            _VerticalDividerWidget(),
            _CompactMetricWidget(
              value: '40 VAGAS',
              label: 'Semestrais',
              icon: Icons.groups_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalDividerWidget extends StatelessWidget {
  const _VerticalDividerWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.0,
      height: 32.0,
      color: Theme.of(context).colorScheme.onSurface.withAlpha(15),
    );
  }
}

class _CompactMetricWidget extends StatelessWidget {
  const _CompactMetricWidget({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
    double? spacing,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontWeight: weight,
      letterSpacing: spacing,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22.0, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: _textStyle(context, size: 13.0, weight: FontWeight.w900),
          ),
          Text(
            label.toUpperCase(),
            style: _textStyle(
              context,
              size: 8.0,
              weight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
              spacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
