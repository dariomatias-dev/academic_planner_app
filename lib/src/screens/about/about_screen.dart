import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_buttons.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  TextStyle _textStyle({
    double size = 14,
    Color color = AppColors.textMain,
    FontWeight weight = FontWeight.w500,
    double? spacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color,
      fontWeight: weight,
      letterSpacing: spacing,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 24.0),
              _buildHeader(),
              _buildBrandingSection(),
              _buildMetricBadges(),
              const SizedBox(height: 48.0),
              _buildMissionStatement(),
              const SizedBox(height: 56.0),
              _buildSection("Funcionalidades", _buildBenefitList()),
              const SizedBox(height: 64.0),
              _buildSection("Especificações", _buildTechnicalSheet()),
              const SizedBox(height: 64.0),
              const Divider(color: AppColors.borderMedium, thickness: 1.0),
              const SizedBox(height: 48.0),
              _buildProfessionalFooter(),
              const SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: _textStyle(
            size: 11,
            color: AppColors.accent,
            weight: FontWeight.w900,
            spacing: 1.5,
          ),
        ),
        const SizedBox(height: 28.0),
        content,
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        const BackIconButtonWidget(),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Apresentação",
                style: _textStyle(
                  size: 10,
                  color: AppColors.accent,
                  weight: FontWeight.w900,
                  spacing: 1.5,
                ),
              ),
              Text(
                "Sobre o App",
                style: _textStyle(size: 20, weight: FontWeight.w800),
              ),
            ],
          ),
        ),
        IconButtonWidget(
          icon: Icons.share_rounded,
          onPressed: () {},
          style: IconButtonStyles.primary,
        ),
      ],
    );
  }

  Widget _buildBrandingSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withAlpha(40),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: AppColors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            "Academic Planner",
            style: _textStyle(size: 28, weight: FontWeight.w900, spacing: -0.5),
          ),
          const SizedBox(height: 4.0),
          Text(
            "Gestão Educacional Inteligente",
            style: _textStyle(
              color: AppColors.textSub,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBadges() {
    return Row(
      children: <Widget>[
        _impactBadge("Foco", Icons.center_focus_strong_rounded),
        const SizedBox(width: 12.0),
        _impactBadge("Gestão", Icons.auto_graph_rounded),
        const SizedBox(width: 12.0),
        _impactBadge("Eficaz", Icons.bolt_rounded),
      ],
    );
  }

  Widget _impactBadge(String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: AppColors.accent.withAlpha(15),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          children: <Widget>[
            Icon(icon, color: AppColors.primary, size: 28.0),
            const SizedBox(height: 12.0),
            Text(
              label,
              style: _textStyle(
                color: AppColors.primary,
                weight: FontWeight.w800,
                size: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionStatement() {
    return Text(
      "Desenvolvido para transformar a rotina estudantil, o Academic Planner centraliza disciplinas, prazos e metas em uma interface direta. Nosso objetivo é reduzir a carga cognitiva, permitindo que você mantenha a atenção onde ela realmente importa.",
      textAlign: TextAlign.center,
      style: _textStyle(
        color: AppColors.textSub,
        weight: FontWeight.w500,
        size: 15,
        height: 1.8,
      ),
    );
  }

  Widget _buildBenefitList() {
    final benefits = [
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
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(b[2] as IconData, color: AppColors.accent, size: 24),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b[0] as String,
                          style: _textStyle(weight: FontWeight.w800, size: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          b[1] as String,
                          style: _textStyle(
                            color: AppColors.textSub,
                            size: 14,
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

  Widget _buildTechnicalSheet() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.borderLight, width: 2.0),
      ),
      child: Column(
        children: [
          _infoRow("Versão Instalada", "1.0.0", false),
          _infoRow("Plataforma Principal", "Android OS", false),
          _infoRow("Tecnologia Base", "Flutter", true),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, bool isLast) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.borderLight, width: 1.5),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: _textStyle(
              color: AppColors.textSub,
              size: 13,
              weight: FontWeight.w600,
            ),
          ),
          Text(value, style: _textStyle(size: 13, weight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildProfessionalFooter() {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.verified_rounded, color: AppColors.accent, size: 24),
          const SizedBox(height: 16.0),
          Text(
            "Academic Planner Professional",
            style: _textStyle(size: 15, weight: FontWeight.w800),
          ),
          const SizedBox(height: 6.0),
          Text(
            "© 2026 Todos os direitos reservados",
            style: _textStyle(
              color: AppColors.textSub.withAlpha(140),
              size: 12,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24.0),
          Container(
            height: 4.0,
            width: 40.0,
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha(40),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ],
      ),
    );
  }
}
