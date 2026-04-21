import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownFieldWidget<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T? value)? onChanged;
  final String? hint;
  final Widget? prefixIcon;
  final String? Function(T? value)? validator;

  const DropdownFieldWidget({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: colorScheme.onSurface.withAlpha(100),
      ),
      dropdownColor: colorScheme.surface,
      borderRadius: BorderRadius.circular(20.0),
      elevation: 16,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: colorScheme.surface,
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface.withAlpha(100),
        ),
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: colorScheme.primary.withAlpha(100),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: colorScheme.error.withAlpha(100),
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),
    );
  }
}
