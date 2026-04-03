import 'package:flutter/material.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? heroTag;

  const FloatingActionButtonWidget({
    super.key,
    required this.onPressed,
    required this.icon,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Icon(icon, color: colorScheme.onPrimary, size: 24.0),
    );
  }
}
