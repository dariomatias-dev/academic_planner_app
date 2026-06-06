import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/di/app_version_provider.dart';

import 'package:academic_planner/src/features/about/presentation/screens/about/widgets/about_source_code_card_widget.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
    double? spacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: spacing,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(title: "Sobre o App"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBrandingSection(context),
            _buildMetricBadges(context),
            const SizedBox(height: 48.0),
            _buildMissionStatement(context),
            const SizedBox(height: 56.0),
            _buildSection(
              context,
              "Funcionalidades",
              _buildBenefitList(context),
            ),
            const SizedBox(height: 64.0),
            _buildSection(
              context,
              "Especificações",
              _buildTechnicalSheet(context),
            ),
            const SizedBox(height: 32.0),
            const AboutSourceCodeCardWidget(),
            const SizedBox(height: 32.0),
            const Divider(),
            const SizedBox(height: 48.0),
            _buildProfessionalFooter(context),
            const SizedBox(height: 48.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: _textStyle(
            context,
            size: 11.0,
            color: Theme.of(context).colorScheme.primary,
            weight: FontWeight.w900,
            spacing: 1.5,
          ),
        ),
        const SizedBox(height: 28.0),
        content,
      ],
    );
  }

  Widget _buildBrandingSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withAlpha(40),
                  blurRadius: 24.0,
                  offset: const Offset(0.0, 8.0),
                ),
              ],
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              color: colorScheme.onPrimary,
              size: 48.0,
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            "Academic Planner",
            style: _textStyle(
              context,
              size: 28.0,
              weight: FontWeight.w900,
              spacing: -0.5,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            "Gestão Educacional Inteligente",
            style: _textStyle(
              context,
              color: colorScheme.onSurface.withAlpha(160),
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBadges(BuildContext context) {
    return Row(
      children: [
        _impactBadge(context, "Foco", Icons.center_focus_strong_rounded),
        const SizedBox(width: 12.0),
        _impactBadge(context, "Gestão", Icons.auto_graph_rounded),
        const SizedBox(width: 12.0),
        _impactBadge(context, "Eficaz", Icons.bolt_rounded),
      ],
    );
  }

  Widget _impactBadge(BuildContext context, String label, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          children: [
            Icon(icon, color: colorScheme.primary, size: 28.0),
            const SizedBox(height: 12.0),
            Text(
              label,
              style: _textStyle(
                context,
                color: colorScheme.primary,
                weight: FontWeight.w800,
                size: 13.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionStatement(BuildContext context) {
    return Text(
      "Desenvolvido para transformar a rotina estudantil, o Academic Planner centraliza disciplinas, prazos e metas em uma interface direta. Nosso objetivo é reduzir a carga cognitiva, permitindo que você mantenha a atenção onde ela realmente importa.",
      textAlign: TextAlign.center,
      style: _textStyle(
        context,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
        weight: FontWeight.w500,
        size: 15.0,
        height: 1.8,
      ),
    );
  }

  Widget _buildBenefitList(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<List<Object>> benefits = [
      [
        "Acompanhamento de Evolução",
        "Mantenha um registro fiel de notas, faltas e seu desempenho geral.",
        Icons.verified_outlined,
      ],
      [
        "Controle de Cronograma",
        "Visualize seus horários e prazos em um mapa semântico claro.",
        Icons.calendar_today_outlined,
      ],
      [
        "Privacidade Total",
        "Dados armazenados localmente, garantindo sua total segurança.",
        Icons.security_outlined,
      ],
    ];

    return Column(
      children: benefits
          .map(
            (List<Object> b) => Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    b[2] as IconData,
                    color: colorScheme.primary,
                    size: 24.0,
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b[0] as String,
                          style: _textStyle(
                            context,
                            weight: FontWeight.w800,
                            size: 15.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          b[1] as String,
                          style: _textStyle(
                            context,
                            color: colorScheme.onSurface.withAlpha(160),
                            size: 14.0,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTechnicalSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.transparent,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final appVersion = ref.watch(appVersionProvider);

              return _infoRow(
                context,
                "Versão Instalada",
                appVersion.maybeWhen(
                  data: (version) => version,
                  orElse: () => "•.•.•",
                ),
                false,
              );
            },
          ),
          _infoRow(context, "Plataforma Principal", "Android OS", false),
          _infoRow(context, "Tecnologia Base", "Flutter", true),
        ],
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    String label,
    String value,
    bool isLast,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: theme.dividerTheme.color ?? Colors.transparent,
                  width: 1.0,
                ),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: _textStyle(
              context,
              color: colorScheme.onSurface.withAlpha(160),
              size: 13.0,
              weight: FontWeight.w600,
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

  Widget _buildProfessionalFooter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          Icon(Icons.verified_rounded, color: colorScheme.primary, size: 24.0),
          const SizedBox(height: 16.0),
          Text(
            "Academic Planner Professional",
            style: _textStyle(context, size: 15.0, weight: FontWeight.w800),
          ),
          const SizedBox(height: 6.0),
          Text(
            "© 2026 Todos os direitos reservados",
            style: _textStyle(
              context,
              color: colorScheme.onSurface.withAlpha(100),
              size: 12.0,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24.0),
          Container(
            height: 4.0,
            width: 40.0,
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(40),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ],
      ),
    );
  }
}
