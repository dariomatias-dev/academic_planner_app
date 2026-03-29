import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchWidget({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: colorScheme.primary,
      activeTrackColor: colorScheme.primary.withAlpha(80),
      trackColor: WidgetStatePropertyAll<Color>(colorScheme.surface),
      trackOutlineColor: WidgetStatePropertyAll<Color>(
        colorScheme.onSurface.withAlpha(50),
      ),
      trackOutlineWidth: const WidgetStatePropertyAll<double>(1.0),
      inactiveThumbColor: colorScheme.onSurface.withAlpha(100),
      inactiveTrackColor: colorScheme.onSurface.withAlpha(40),
    );
  }
}
