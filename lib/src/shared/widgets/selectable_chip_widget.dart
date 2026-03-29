import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectableChipWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool isSelected;

  const SelectableChipWidget({
    super.key,
    required this.onTap,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? colorScheme.primary : colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        labelStyle: GoogleFonts.plusJakartaSans(
          color: isSelected
              ? colorScheme.onPrimary
              : colorScheme.onSurface.withAlpha(160),
          fontWeight: FontWeight.w700,
          fontSize: 12.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide.none,
        ),
      ),
    );
  }
}
