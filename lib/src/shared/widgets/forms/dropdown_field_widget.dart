import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownFieldWidget<T> extends StatelessWidget {
  const DropdownFieldWidget({
    required this.items,
    super.key,
    this.value,
    this.onChanged,
    this.hint,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T? value)? onChanged;
  final String? hint;
  final Widget? prefixIcon;
  final String? Function(T? value)? validator;
  final bool enabled;

  static const _radius = 16.0;
  static const _contentPadding = EdgeInsets.all(16);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isActuallyEnabled = enabled && onChanged != null;

    final effectiveFillColor = isActuallyEnabled
        ? colorScheme.surface
        : colorScheme.onSurface.withAlpha(15);

    final effectiveBorderColor =
        theme.dividerTheme.color ?? colorScheme.onSurface.withAlpha(30);

    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: colorScheme.onSurface.withAlpha(100),
      ),
      dropdownColor: colorScheme.surface,
      borderRadius: BorderRadius.circular(_radius),
      elevation: 16,
      style: _textStyle(colorScheme).copyWith(
        color: isActuallyEnabled
            ? colorScheme.onSurface
            : colorScheme.onSurface.withAlpha(140),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: effectiveFillColor,
        hintText: hint,
        hintStyle: _hintStyle(colorScheme),
        prefixIcon: prefixIcon != null
            ? Opacity(opacity: isActuallyEnabled ? 1.0 : 0.5, child: prefixIcon)
            : null,
        contentPadding: _contentPadding,
        border: _border(effectiveBorderColor),
        enabledBorder: _border(effectiveBorderColor),
        focusedBorder: _border(effectiveBorderColor),
        errorBorder: _border(colorScheme.error),
        focusedErrorBorder: _border(colorScheme.error),
        errorStyle: _errorStyle(colorScheme),
      ),
    );
  }

  TextStyle _textStyle(ColorScheme colors) {
    return GoogleFonts.plusJakartaSans(
      fontWeight: FontWeight.w600,
      fontSize: 14.0,
    );
  }

  TextStyle _hintStyle(ColorScheme colors) {
    return GoogleFonts.plusJakartaSans(
      color: colors.onSurface.withAlpha(100),
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
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
      borderSide: BorderSide(color: color),
    );
  }
}
