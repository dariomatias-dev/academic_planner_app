import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({super.key, required this.onTap, required this.text});

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 13.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
