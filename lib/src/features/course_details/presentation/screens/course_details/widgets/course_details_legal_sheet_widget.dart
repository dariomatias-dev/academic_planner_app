import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseDetailsLegalSheetWidget extends StatelessWidget {
  const CourseDetailsLegalSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(5),
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: const Column(
        children: [
          _LegalRowWidget(
            label: 'Portaria Autorizativa',
            value: 'nº 2.809 (2017)',
          ),
          _LegalRowWidget(label: 'Data de Criação', value: '01/12/2017'),
          _LegalRowWidget(label: 'Turno do Curso', value: 'Integral'),
          _LegalRowWidget(
            label: 'Código e-MEC',
            value: '1406836',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _LegalRowWidget extends StatelessWidget {
  const _LegalRowWidget({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withAlpha(120),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.0,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
