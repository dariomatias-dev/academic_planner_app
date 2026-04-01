import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/theme/theme_controller.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/screens/settings/widgets/settings_profile_header_widget.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/notification_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/switch_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Provider.of<ThemeController>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppBarWidget(
        title: "Ajustes do App",
        actions: <Widget>[NotificationButtonWidget()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SettingsProfileHeaderWidget(
              name: "John Doe",
              email: "john.doe@ifpb.edu.br",
              course: "Análise e Desenvolvimento de Sistemas",
              campus: "Esperança",
            ),
            const SizedBox(height: 32.0),
            _buildSectionTitle(context, "Informações do Curso"),
            _buildSettingsTile(
              context,
              icon: Icons.list_alt_rounded,
              title: "Disciplinas do Curso",
              onTap: () => AppRoutes.goToDisciplines(context),
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle(context, "Preferências"),
            _buildSettingsTile(
              context,
              icon: Icons.notifications_none_rounded,
              title: "Notificações",
              onTap: () {
                setState(() {
                  _notificationsEnabled = !_notificationsEnabled;
                });
              },
              trailing: IgnorePointer(
                child: SwitchWidget(
                  value: _notificationsEnabled,
                  onChanged: (value) {},
                ),
              ),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.dark_mode_outlined,
              title: "Modo Escuro",
              onTap: themeController.toggleTheme,
              trailing: IgnorePointer(
                child: SwitchWidget(
                  value: themeController.isDarkMode,
                  onChanged: (value) {},
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle(context, "Conta"),
            _buildSettingsTile(
              context,
              icon: Icons.person_outline_rounded,
              title: "Dados Pessoais",
              onTap: () {},
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle(context, "Suporte"),
            _buildSettingsTile(
              context,
              icon: Icons.help_outline_rounded,
              title: "Central de Ajuda",
              onTap: () {},
            ),
            _buildSettingsTile(
              context,
              icon: Icons.info_outline_rounded,
              title: "Sobre o App",
              onTap: () => AppRoutes.goToAbout(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SizedBox(height: 110.0),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 12.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          color: isDark ? AppColors.slate400 : AppColors.slate700,
          fontSize: 11.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: theme.dividerTheme.color ?? AppColors.transparent,
          width: 1.0,
        ),
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.zinc800 : AppColors.slate100,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Icon(icon, color: colorScheme.onSurface, size: 20.0),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onSurface,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.slate400,
                      size: 24.0,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
