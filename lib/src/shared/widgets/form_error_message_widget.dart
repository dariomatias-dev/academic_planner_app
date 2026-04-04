import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormErrorMessageWidget extends StatelessWidget {
  final bool hasError;
  final String? errorText;

  const FormErrorMessageWidget({
    super.key,
    required this.hasError,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: hasError ? 26.0 : 0.0,
      child: Align(
        alignment: Alignment.topLeft,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          offset: hasError ? Offset.zero : const Offset(0, -0.3),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 120),
            opacity: hasError ? 1 : 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0),
              child: Text(
                errorText ?? '',
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.error,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
