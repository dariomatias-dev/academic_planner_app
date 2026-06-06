import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/theme_selector_modal/theme_selector_modal_option_widget.dart';

class ThemeSelectorModalWidget extends StatelessWidget {
  final ThemeMode currentMode;
  final Function(ThemeMode) onModeSelected;

  const ThemeSelectorModalWidget({
    super.key,
    required this.currentMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentGeometry.center,
          child: Text(
            "Escolha o tema",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 24.0),
        ThemeSelectorModalOptionWidget(
          onTap: () => onModeSelected(ThemeMode.light),
          label: 'Modo Claro',
          icon: Icons.light_mode_rounded,
          isSelected: currentMode == ThemeMode.light,
        ),
        ThemeSelectorModalOptionWidget(
          onTap: () => onModeSelected(ThemeMode.dark),
          label: 'Modo Escuro',
          icon: Icons.dark_mode_rounded,
          isSelected: currentMode == ThemeMode.dark,
        ),
        ThemeSelectorModalOptionWidget(
          onTap: () => onModeSelected(ThemeMode.system),
          label: 'Padrão do Sistema',
          icon: Icons.settings_brightness_rounded,
          isSelected: currentMode == ThemeMode.system,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
