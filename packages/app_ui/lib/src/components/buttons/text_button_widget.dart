import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({required this.onTap, required this.text, super.key});

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        style: AppTypography.style(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 13.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
