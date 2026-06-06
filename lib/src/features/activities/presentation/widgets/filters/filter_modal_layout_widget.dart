import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';

class FilterModalLayoutWidget extends StatelessWidget {
  final String title;
  final VoidCallback onClear;
  final VoidCallback onApply;
  final List<Widget> children;

  const FilterModalLayoutWidget({
    super.key,
    required this.title,
    required this.onClear,
    required this.onApply,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.6;

    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 32.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48.0,
              height: 5.0,
              margin: const EdgeInsets.only(bottom: 24.0),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withAlpha(20),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface,
                fontSize: 22.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  onPressed: onClear,
                  label: 'Limpar',
                  style: AppButtonStyle.outline,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ButtonWidget(
                  onPressed: onApply,
                  label: 'Aplicar Filtros',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
