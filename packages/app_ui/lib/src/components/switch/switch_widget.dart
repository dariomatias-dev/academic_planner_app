import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  const SwitchWidget({required this.value, required this.onChanged, super.key});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 58.0,
        height: 34.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: value
              ? colorScheme.primary.withAlpha(30)
              : colorScheme.surface,
          border: Border.all(
            color: value
                ? colorScheme.primary.withAlpha(80)
                : (theme.dividerTheme.color ?? Colors.transparent),
            width: 2.0,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOutQuart,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              width: 22.0,
              height: 22.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value
                    ? colorScheme.primary
                    : colorScheme.onSurface.withAlpha(60),
                boxShadow: [
                  if (value)
                    BoxShadow(
                      color: colorScheme.primary.withAlpha(60),
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 4.0),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
