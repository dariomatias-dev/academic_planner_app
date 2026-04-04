import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

enum InputStyle { primary, secondary }

class InputWidget extends StatelessWidget {
  const InputWidget({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.style = InputStyle.primary,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffix;
  final String? Function(String? value)? validator;
  final InputStyle style;

  static const double _radius = 16.0;
  static const EdgeInsets _contentPadding = EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isPrimary = style == InputStyle.primary;
    final effectiveFillColor = isPrimary
        ? colors.surface
        : theme.scaffoldBackgroundColor;
    final effectiveBorderColor =
        theme.dividerTheme.color ?? AppColors.transparent;

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
        fillColor: effectiveFillColor,
        border: _border(effectiveBorderColor),
        enabledBorder: _border(effectiveBorderColor),
        focusedBorder: _border(colors.primary),
        errorBorder: _border(colors.error),
        focusedErrorBorder: _border(colors.error),
        contentPadding: _contentPadding,
      ),
      onTapUpOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  TextStyle _textStyle(ColorScheme colors) {
    return GoogleFonts.plusJakartaSans(
      color: colors.onSurface,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _hintStyle(ColorScheme colors) {
    return GoogleFonts.plusJakartaSans(
      color: colors.onSurface.withAlpha(100),
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle _errorStyle(ColorScheme colors) {
    return GoogleFonts.plusJakartaSans(
      color: colors.error,
      fontWeight: FontWeight.w600,
      fontSize: 12.0,
    );
  }

  OutlineInputBorder _border(Color color) {
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
      builder: (BuildContext context, Widget? child) {
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
