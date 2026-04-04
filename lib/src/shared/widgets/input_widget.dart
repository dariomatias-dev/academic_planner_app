import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffix,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffix;
  final String? Function(String? value)? validator;

  static const _radius = 16.0;
  static const _contentPadding = EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: _textStyle(colors),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: _hintStyle(colors),
        errorStyle: _errorStyle(colors),
        prefixIcon: prefixIcon,
        suffixIcon: suffix ?? _ClearButtonWidget(controller: controller),
        filled: true,
        fillColor: colors.surface,
        border: _border(color: theme.dividerTheme.color ?? Colors.transparent),
        enabledBorder: _border(
          color: theme.dividerTheme.color ?? AppColors.transparent,
        ),
        focusedBorder: _border(color: colors.primary),
        errorBorder: _border(color: colors.error),
        focusedErrorBorder: _border(color: colors.error),
        contentPadding: _contentPadding,
      ),
      onTapUpOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }

  TextStyle _textStyle(ColorScheme colorScheme) {
    return GoogleFonts.plusJakartaSans(
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _hintStyle(ColorScheme colorScheme) {
    return GoogleFonts.plusJakartaSans(
      color: colorScheme.onSurface.withAlpha(100),
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle _errorStyle(ColorScheme colorScheme) {
    return GoogleFonts.plusJakartaSans(
      color: colorScheme.error,
      fontWeight: FontWeight.w600,
      fontSize: 12.0,
    );
  }

  OutlineInputBorder _border({required Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: BorderSide(color: color, width: 1.0),
    );
  }
}

class _ClearButtonWidget extends StatelessWidget {
  const _ClearButtonWidget({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (_, _) {
        if (controller.text.isEmpty) return const SizedBox.shrink();

        return IconButton(
          onPressed: controller.clear,
          icon: Icon(
            Icons.clear_rounded,
            size: 20.0,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
          ),
        );
      },
    );
  }
}
