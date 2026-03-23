import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/screens/disciplines/disciplines_screen.dart';
import 'package:academic_planner/src/screens/schedule/schedule_screen.dart';

import 'package:academic_planner/src/shared/widgets/switch_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.borderMedium, width: 1.0),
        ),
        toolbarHeight: 80.0,
        title: Text(
          "Ajustes do App",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textMain,
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildProfileCard(),
            const SizedBox(height: 32.0),
            _buildSectionTitle("Informações do Curso"),
            _buildSettingsTile(
              icon: Icons.list_alt_rounded,
              title: "Disciplinas do Curso",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DisciplinesScreen(),
                  ),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.grid_on_rounded,
              title: "Grade Curricular Geral",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScheduleScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle("Preferências"),
            _buildSettingsTile(
              icon: Icons.notifications_none_rounded,
              title: "Notificações",
              trailing: SwitchWidget(
                value: _notificationsEnabled,
                onChanged: (value) =>
                    setState(() => _notificationsEnabled = value),
              ),
            ),
            _buildSettingsTile(
              icon: Icons.dark_mode_outlined,
              title: "Modo Escuro",
              trailing: SwitchWidget(
                value: _darkMode,
                onChanged: (value) => setState(() => _darkMode = value),
              ),
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle("Conta"),
            _buildSettingsTile(
              icon: Icons.person_outline_rounded,
              title: "Dados Pessoais",
              onTap: () {},
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle("Suporte"),
            _buildSettingsTile(
              icon: Icons.help_outline_rounded,
              title: "Central de Ajuda",
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.info_outline_rounded,
              title: "Sobre o App",
              onTap: () {},
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.borderMedium, width: 1.5),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.textMain.withAlpha(10),
            blurRadius: 20.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(25),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withAlpha(50),
                width: 2.0,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 32.0,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "John Doe",
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textMain,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "john.doe@university.com",
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textSub,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: AppColors.bg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            icon: const Icon(
              Icons.edit_rounded,
              color: AppColors.primary,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 12.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.textSub,
          fontSize: 11.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.borderLight, width: 1.0),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),
        leading: Container(
          width: 42.0,
          height: 42.0,
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Icon(icon, color: AppColors.textMain, size: 20.0),
        ),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textMain,
            fontSize: 15.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing:
            trailing ??
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSub,
              size: 24.0,
            ),
      ),
    );
  }
}
