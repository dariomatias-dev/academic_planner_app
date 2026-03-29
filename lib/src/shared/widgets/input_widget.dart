import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final Widget? suffix;
  final String? Function(String? value)? validator;

  const InputWidget({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.plusJakartaSans(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: colorScheme.onSurface.withAlpha(100),
          fontWeight: FontWeight.w500,
        ),
        errorStyle: GoogleFonts.plusJakartaSans(
          color: colorScheme.error,
          fontWeight: FontWeight.w600,
          fontSize: 12.0,
        ),
        suffixIcon:
            suffix ??
            ListenableBuilder(
              listenable: controller,
              builder: (context, child) {
                if (controller.text.isEmpty) return const SizedBox.shrink();

                return IconButton(
                  onPressed: controller.clear,
                  icon: Icon(
                    Icons.clear_rounded,
                    size: 20.0,
                    color: colorScheme.onSurface.withAlpha(160),
                  ),
                );
              },
            ),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: theme.dividerTheme.color ?? AppColors.transparent,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(16.0),
      ),
      onTapUpOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
