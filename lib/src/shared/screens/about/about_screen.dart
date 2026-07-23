import 'package:academic_planner/src/shared/screens/about/widgets/about_benefit_list_widget.dart';
import 'package:academic_planner/src/shared/screens/about/widgets/about_branding_section_widget.dart';
import 'package:academic_planner/src/shared/screens/about/widgets/about_metric_badges_widget.dart';
import 'package:academic_planner/src/shared/screens/about/widgets/about_mission_statement_widget.dart';
import 'package:academic_planner/src/shared/screens/about/widgets/about_professional_footer_widget.dart';
import 'package:academic_planner/src/shared/screens/about/widgets/about_section_widget.dart';
import 'package:academic_planner/src/shared/screens/about/widgets/about_source_code_card_widget.dart';
import 'package:academic_planner/src/shared/screens/about/widgets/about_technical_sheet_widget.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const AppBarWidget(title: 'Sobre o App'),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AboutBrandingSectionWidget(),
            AboutMetricBadgesWidget(),
            SizedBox(height: 48.0),
            AboutMissionStatementWidget(),
            SizedBox(height: 56.0),
            AboutSectionWidget(
              title: 'Funcionalidades',
              child: AboutBenefitListWidget(),
            ),
            SizedBox(height: 64.0),
            AboutSectionWidget(
              title: 'Especificações',
              child: AboutTechnicalSheetWidget(),
            ),
            SizedBox(height: 32.0),
            AboutSourceCodeCardWidget(),
            SizedBox(height: 32.0),
            Divider(),
            SizedBox(height: 48.0),
            AboutProfessionalFooterWidget(),
            SizedBox(height: 48.0),
          ],
        ),
      ),
    );
  }
}
