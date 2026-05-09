import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/logging/logger_provider.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/shared/utils/open_url.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  static const _ppcUrl =
      'https://estudante.ifpb.edu.br/media/cursos/346/documentos/PPC_ADS_Esperanca_Resolucao.pdf';
  static const _ifpbLogo =
      'https://cdn.brandfetch.io/id27nEqSG5/w/300/h/331/theme/dark/logo.png?c=1bxid64Mup7aczewSAYMX&t=1772898954763';

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
    double? spacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontWeight: weight,
      letterSpacing: spacing,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "Detalhes do Curso",
        actions: <Widget>[
          Consumer(
            builder: (context, ref, child) {
              return IconButtonWidget(
                icon: Icons.launch_rounded,
                onPressed: () {
                  openUrl(
                    context,
                    'https://estudante.ifpb.edu.br/cursos/346/',
                    logger: ref.read(loggerProvider),
                  );
                },
                style: IconButtonStyle.primary,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            _buildImpactfulHero(context),
            Transform.translate(
              offset: const Offset(0.0, -36.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    _buildFloatingMetricsCard(context),
                    const SizedBox(height: 40.0),
                    _buildMainContent(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactfulHero(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colorScheme.primary,
            colorScheme.primary.withBlue(160),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(48.0),
          bottomRight: Radius.circular(48.0),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -40,
            top: -20,
            child: Icon(
              Icons.terminal_rounded,
              size: 240,
              color: colorScheme.onPrimary.withAlpha(15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28.0, 48.0, 28.0, 96.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withAlpha(35),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    "CURSO SUPERIOR",
                    style: _textStyle(
                      context,
                      size: 10.0,
                      weight: FontWeight.w900,
                      color: colorScheme.onPrimary,
                      spacing: 2.0,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Text(
                  "Análise e\nDesenvolvimento\nde Sistemas",
                  style: _textStyle(
                    context,
                    size: 36.0,
                    weight: FontWeight.w900,
                    color: colorScheme.onPrimary,
                    height: 1.1,
                    spacing: -1.0,
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        color: colorScheme.onPrimary,
                        size: 16.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      "IFPB Campus Esperança",
                      style: _textStyle(
                        context,
                        size: 16.0,
                        weight: FontWeight.w700,
                        color: colorScheme.onPrimary.withAlpha(210),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingMetricsCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 40.0,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(color: colorScheme.onSurface.withAlpha(10)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            _compactMetric(context, "3 ANOS", "Duração", Icons.timer_outlined),
            _verticalDivider(context),
            _compactMetric(
              context,
              "2.084H",
              "Carga",
              Icons.history_edu_rounded,
            ),
            _verticalDivider(context),
            _compactMetric(
              context,
              "40 VAGAS",
              "Semestrais",
              Icons.groups_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalDivider(BuildContext context) {
    return Container(
      width: 1.0,
      height: 32.0,
      color: Theme.of(context).colorScheme.onSurface.withAlpha(15),
    );
  }

  Widget _compactMetric(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Icon(icon, size: 22.0, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: _textStyle(context, size: 13.0, weight: FontWeight.w900),
          ),
          Text(
            label.toUpperCase(),
            style: _textStyle(
              context,
              size: 8.0,
              weight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
              spacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionHeader(context, "Visão Geral"),
        const SizedBox(height: 16.0),
        _buildAboutText(context),
        const SizedBox(height: 40.0),
        _buildSectionHeader(context, "O que você irá aprender"),
        const SizedBox(height: 20.0),
        _buildSkillGrid(context),
        const SizedBox(height: 48.0),
        _buildSectionHeader(context, "Recursos Oficiais"),
        const SizedBox(height: 20.0),
        _buildActionTiles(context),
        const SizedBox(height: 48.0),
        _buildSectionHeader(context, "Gestão do Curso"),
        const SizedBox(height: 20.0),
        _buildCoordinationCard(context),
        const SizedBox(height: 48.0),
        _buildSectionHeader(context, "Dados Administrativos"),
        const SizedBox(height: 20.0),
        _buildLegalSheet(context),
        const SizedBox(height: 64.0),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: <Widget>[
        Container(
          width: 4.0,
          height: 16.0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        const SizedBox(width: 12.0),
        Text(
          title.toUpperCase(),
          style: _textStyle(
            context,
            size: 11.0,
            weight: FontWeight.w900,
            color: Theme.of(context).colorScheme.primary,
            spacing: 2.0,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutText(BuildContext context) {
    return Text(
      "O Tecnólogo em Análise e Desenvolvimento de Sistemas do IFPB Campus Esperança é capacitado para analisar, projetar, documentar, testar, implantar e manter sistemas computacionais de informação. Sua atuação engloba a produção de softwares com qualidade, usabilidade, integridade e segurança, focando em soluções inovadoras para o mercado global.",
      style: _textStyle(
        context,
        size: 15.0,
        height: 1.8,
        weight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
      ),
    );
  }

  Widget _buildSkillGrid(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final skills = <Map<String, dynamic>>[
      {"label": "Software", "icon": Icons.code_rounded},
      {"label": "Redes", "icon": Icons.lan_rounded},
      {"label": "Dados", "icon": Icons.storage_rounded},
      {"label": "Mobile", "icon": Icons.smartphone_rounded},
      {"label": "Segurança", "icon": Icons.security_rounded},
      {"label": "DevOps", "icon": Icons.all_inclusive_rounded},
    ];

    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: skills.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: colorScheme.onSurface.withAlpha(10)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                skill['icon'] as IconData,
                size: 16.0,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8.0),
              Text(
                skill['label'] as String,
                style: _textStyle(context, size: 13.0, weight: FontWeight.w800),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionTiles(BuildContext context) {
    return Column(
      children: <Widget>[
        _customAction(
          context,
          "Projeto Pedagógico (PPC)",
          "Regras, diretrizes e matriz curricular oficial.",
          Icons.picture_as_pdf_rounded,
          Colors.redAccent,
          () {
            AppRoutes.goToPdfViewer(
              context,
              url: _ppcUrl,
              title: "PPC ADS Esperança",
            );
          },
        ),
        const SizedBox(height: 16.0),
        _customAction(
          context,
          "Estrutura Curricular",
          "Lista detalhada de disciplinas por período.",
          Icons.auto_awesome_mosaic_rounded,
          Theme.of(context).colorScheme.primary,
          () {
            AppRoutes.goToDisciplines(context);
          },
        ),
      ],
    );
  }

  Widget _customAction(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
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
          children: <Widget>[
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
                children: <Widget>[
                  Text(
                    title,
                    style: _textStyle(
                      context,
                      weight: FontWeight.w800,
                      size: 15.0,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: _textStyle(
                      context,
                      size: 12.0,
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

  Widget _buildCoordinationCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.primary.withAlpha(30),
            blurRadius: 20.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                backgroundColor: colorScheme.onPrimary.withAlpha(40),
                child: Icon(
                  Icons.person_3_rounded,
                  color: colorScheme.onPrimary,
                  size: 32.0,
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Valderi Reis da Silva",
                      style: _textStyle(
                        context,
                        size: 18.0,
                        weight: FontWeight.w900,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      "Coordenador de ADS",
                      style: _textStyle(
                        context,
                        size: 13.0,
                        weight: FontWeight.w600,
                        color: colorScheme.onPrimary.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 14.0,
            ),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withAlpha(30),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.alternate_email_rounded,
                  size: 18.0,
                  color: colorScheme.onPrimary,
                ),
                const SizedBox(width: 12.0),
                Text(
                  "ads.esperanca@ifpb.edu.br",
                  style: _textStyle(
                    context,
                    weight: FontWeight.w700,
                    size: 13.0,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalSheet(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(5),
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Column(
        children: <Widget>[
          _legalRow(context, "Portaria Autorizativa", "nº 2.809 (2017)"),
          _legalRow(context, "Data de Criação", "01/12/2017"),
          _legalRow(context, "Turno do Curso", "Integral"),
          _legalRow(context, "Código e-MEC", "1406836", isLast: true),
        ],
      ),
    );
  }

  Widget _legalRow(
    BuildContext context,
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: _textStyle(
              context,
              size: 13.0,
              weight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
            ),
          ),
          Text(
            value,
            style: _textStyle(context, size: 13.0, weight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: <Widget>[
        Center(child: Image.network(_ifpbLogo, height: 70.0)),
        const SizedBox(height: 24.0),
        Text(
          "Instituto Federal da Paraíba",
          style: _textStyle(context, size: 14.0, weight: FontWeight.w800),
        ),
        const SizedBox(height: 4.0),
        Text(
          "CAMPUS ESPERANÇA",
          style: _textStyle(
            context,
            size: 11.0,
            color: colorScheme.primary,
            weight: FontWeight.w900,
            spacing: 2.0,
          ),
        ),
        const SizedBox(height: 40.0),
      ],
    );
  }
}
