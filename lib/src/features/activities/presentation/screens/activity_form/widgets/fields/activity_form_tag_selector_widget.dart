import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/shared/widgets/filter_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityFormTagSelectorWidget extends StatelessWidget {
  const ActivityFormTagSelectorWidget({
    required this.availableTags,
    required this.selectedTags,
    required this.onToggle,
    required this.onCreate,
    super.key,
  });

  final List<String> availableTags;
  final List<String> selectedTags;
  final void Function(String tag, {bool value}) onToggle;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tags',
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: onCreate,
              child: Text(
                '+ Nova Tag',
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.primary,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: availableTags.builder((tag, index) {
            final isSelected = selectedTags.contains(tag);

            return FilterChipWidget(
              label: tag,
              isSelected: isSelected,
              onSelected: (value) => onToggle(tag, value: value),
            );
          }),
        ),
      ],
    );
  }
}
