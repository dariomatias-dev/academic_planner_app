import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_field.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_order.dart';
import 'package:academic_planner/src/shared/widgets/forms/dropdown_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SortFilterSectionWidget extends StatelessWidget {
  const SortFilterSectionWidget({
    required this.sortField,
    required this.sortOrder,
    required this.onFieldChanged,
    required this.onOrderChanged,
    super.key,
  });

  final ActivitySortField? sortField;
  final ActivitySortOrder? sortOrder;
  final ValueChanged<ActivitySortField?> onFieldChanged;
  final ValueChanged<ActivitySortOrder> onOrderChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = sortField != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ORDENAÇÃO',
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.primary,
            fontSize: 11.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 20.0),
        DropdownFieldWidget<ActivitySortField>(
          hint: 'Ordenar por',
          value: sortField,
          prefixIcon: Icon(
            Icons.swap_vert_rounded,
            color: colorScheme.primary,
            size: 20,
          ),
          items: ActivitySortField.values.builder((field, index) {
            return DropdownMenuItem<ActivitySortField>(
              value: field,
              child: Text(field.label),
            );
          }),
          onChanged: onFieldChanged,
        ),
        const SizedBox(height: 16.0),
        Opacity(
          opacity: isEnabled ? 1.0 : 0.5,
          child: IgnorePointer(
            ignoring: !isEnabled,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withAlpha(10),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Row(
                children: [
                  _buildOrderToggle(
                    context,
                    label: 'Crescente',
                    icon: Icons.south_east_rounded,
                    value: ActivitySortOrder.asc,
                    isSelected: isEnabled && sortOrder == ActivitySortOrder.asc,
                  ),
                  const SizedBox(width: 6.0),
                  _buildOrderToggle(
                    context,
                    label: 'Decrescente',
                    icon: Icons.north_east_rounded,
                    value: ActivitySortOrder.desc,
                    isSelected:
                        isEnabled && sortOrder == ActivitySortOrder.desc,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderToggle(
    BuildContext context, {
    required String label,
    required IconData icon,
    required ActivitySortOrder value,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: () => onOrderChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.0,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withAlpha(100),
              ),
              const SizedBox(width: 8.0),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withAlpha(140),
                  fontSize: 13.0,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
