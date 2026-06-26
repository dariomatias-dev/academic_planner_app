import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityProgressCardWidget extends StatelessWidget {
  const ActivityProgressCardWidget({required this.state, super.key});

  final AsyncValue<double> state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(60),
            blurRadius: 20.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seu Progresso',
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onPrimary.withAlpha(200),
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12.0),
          state.when(
            loading: () {
              return CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colorScheme.onPrimary,
              );
            },
            error: (err, stack) {
              return Icon(Icons.error_outline, color: colorScheme.onPrimary);
            },
            data: (progress) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onPrimary,
                      fontSize: 32.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8.0,
                      backgroundColor: colorScheme.onPrimary.withAlpha(50),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ActivityUrgentCardWidget extends StatelessWidget {
  const ActivityUrgentCardWidget({required this.state, super.key});

  final AsyncValue<int> state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 145.0,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notification_important_rounded,
            color: colorScheme.error,
            size: 28.0,
          ),
          const SizedBox(height: 12.0),
          MetricCardValueWidget(
            color: colorScheme.error,
            state: state,
            fontSize: 24.0,
          ),
          const SizedBox(height: 8.0),
          Text(
            'URGENTES',
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.error.withAlpha(180),
              fontSize: 10.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class MetricCardWidget extends StatelessWidget {
  const MetricCardWidget({
    required this.label,
    required this.icon,
    required this.color,
    super.key,
    this.state,
    this.value,
  });

  final String label;
  final IconData icon;
  final Color color;
  final AsyncValue<int>? state;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color:
              theme.dividerTheme.color ??
              colorScheme.outlineVariant.withAlpha(50),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20.0),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state != null)
                  MetricCardValueWidget(state: state!)
                else
                  Text(
                    value ?? '0',
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onSurface,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                Text(
                  label,
                  style: TextStyle(
                    color: colorScheme.onSurface.withAlpha(140),
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
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

class MetricCardValueWidget extends StatelessWidget {
  const MetricCardValueWidget({
    required this.state,
    super.key,
    this.fontSize = 18.0,
    this.color,
  });
  final AsyncValue<int> state;
  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface;

    return state.when(
      loading: () {
        return SizedBox(
          height: fontSize,
          width: fontSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            color: effectiveColor,
          ),
        );
      },
      error: (err, stack) {
        return Icon(Icons.error_outline, size: fontSize, color: effectiveColor);
      },
      data: (count) {
        return Text(
          count.toString(),
          style: GoogleFonts.plusJakartaSans(
            color: effectiveColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
          ),
        );
      },
    );
  }
}
