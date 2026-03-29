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
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.textMain,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textSub.withAlpha(100),
          fontWeight: FontWeight.w500,
        ),
        errorStyle: GoogleFonts.plusJakartaSans(
          color: Colors.red.shade700,
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
                  icon: const Icon(
                    Icons.clear_rounded,
                    size: 20.0,
                    color: AppColors.textSub,
                  ),
                );
              },
            ),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16.0),
      ),
      onTapUpOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
