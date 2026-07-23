import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseDetailsActionTilesWidget extends StatelessWidget {
  const CourseDetailsActionTilesWidget({super.key});

  static const _ppcUrl =
      'https://estudante.ifpb.edu.br/media/cursos/346/documentos/PPC_ADS_Esperanca_Resolucao.pdf';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CustomActionTileWidget(
          title: 'Projeto Pedagógico (PPC)',
          subtitle: 'Regras, diretrizes e matriz curricular oficial.',
          icon: Icons.picture_as_pdf_rounded,
          color: Colors.redAccent,
          onTap: () async {
            await AppRoutes.goToPdfViewer(
              context,
              url: _ppcUrl,
              title: 'PPC ADS Esperança',
            );
          },
        ),
        const SizedBox(height: 16.0),
        _CustomActionTileWidget(
          title: 'Estrutura Curricular',
          subtitle: 'Lista detalhada de disciplinas por período.',
          icon: Icons.auto_awesome_mosaic_rounded,
          color: Theme.of(context).colorScheme.primary,
          onTap: () async {
            await AppRoutes.goToDisciplines(context);
          },
        ),
      ],
    );
  }
}

class _CustomActionTileWidget extends StatelessWidget {
  const _CustomActionTileWidget({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28.0),
          border: Border.all(color: colorScheme.onSurface.withAlpha(10)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: color.withAlpha(15),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Icon(icon, color: color, size: 24.0),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.0,
                      color: colorScheme.onSurface.withAlpha(120),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.0,
              color: colorScheme.onSurface.withAlpha(40),
            ),
          ],
        ),
      ),
    );
  }
}
