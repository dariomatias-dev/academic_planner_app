import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/theme/theme_controller.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/screens/settings/widgets/settings_profile_header_widget.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/notification_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/modal_bottom_sheet_widget.dart';
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
    final colorScheme = theme.colorScheme;
    final themeController = Provider.of<ThemeController>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppBarWidget(
        label: 'Configurações',
        title: "Ajustes do App",
        actions: <Widget>[NotificationButtonWidget()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 140.0),
        physics: const BouncingScrollPhysics(),
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
              icon: Icons.notifications_active_rounded,
              title: "Notificações",
              onTap: () {
                setState(() {
                  _notificationsEnabled = !_notificationsEnabled;
                });
              },
              trailing: SwitchWidget(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.palette_rounded,
              title: "Tema do Aplicativo",
              onTap: () => _showThemeBottomSheet(context),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(15),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  _getThemeLabel(themeController.themeMode),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            _buildSectionTitle(context, "Suporte"),
            _buildSettingsTile(
              context,
              icon: Icons.help_center_rounded,
              title: "Central de Ajuda",
              onTap: () {},
            ),
            _buildSettingsTile(
              context,
              icon: Icons.info_rounded,
              title: "Sobre o Academic Planner",
              onTap: () => AppRoutes.goToAbout(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    final themeController = context.read<ThemeController>();
    final colorScheme = Theme.of(context).colorScheme;

    ModalBottomSheetWidget.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "APARÊNCIA",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.0,
              fontWeight: FontWeight.w900,
              color: colorScheme.primary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            "Escolha o tema",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24.0),
          _buildThemeOption(
            context,
            label: 'Modo Claro',
            icon: Icons.light_mode_rounded,
            value: ThemeMode.light,
            isSelected: themeController.themeMode == ThemeMode.light,
            onTap: () {
              themeController.setThemeMode(ThemeMode.light);
              Navigator.pop(context);
            },
          ),
          _buildThemeOption(
            context,
            label: 'Modo Escuro',
            icon: Icons.dark_mode_rounded,
            value: ThemeMode.dark,
            isSelected: themeController.themeMode == ThemeMode.dark,
            onTap: () {
              themeController.setThemeMode(ThemeMode.dark);
              Navigator.pop(context);
            },
          ),
          _buildThemeOption(
            context,
            label: 'Padrão do Sistema',
            icon: Icons.settings_brightness_rounded,
            value: ThemeMode.system,
            isSelected: themeController.themeMode == ThemeMode.system,
            onTap: () {
              themeController.setThemeMode(ThemeMode.system);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String label,
    required IconData icon,
    required ThemeMode value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withAlpha(15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary.withAlpha(50)
                  : (theme.dividerTheme.color ?? AppColors.transparent),
              width: 1.0,
            ),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withAlpha(100),
                size: 22.0,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.onSurface,
                    fontSize: 15.0,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: colorScheme.primary,
                  size: 22.0,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Escuro';
      case ThemeMode.system:
        return 'Sistema';
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 16.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          color: colorScheme.onSurface.withAlpha(100),
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
    Color? color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveColor = color ?? colorScheme.onSurface;

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
        color: Colors.transparent,
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
                    color: (color ?? colorScheme.primary).withAlpha(15),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Icon(
                    icon,
                    color: color ?? colorScheme.primary,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      color: effectiveColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurface.withAlpha(60),
                      size: 22.0,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
