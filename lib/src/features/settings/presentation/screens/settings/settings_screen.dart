import 'package:academic_planner/src/core/di/theme_provider.dart';
import 'package:academic_planner/src/core/extensions/theme_mode_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/delete_account/delete_account_confirmation_dialog_widget.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/logout_confirmation_dialog_widget.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/settings_profile_header/settings_profile_header_widget.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/settings_section_widget.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/settings_tile_widget.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/theme_selector_modal/theme_selector_modal_widget.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/modal_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _showThemeBottomSheet(BuildContext context) async {
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    await ModalBottomSheetWidget.show<void>(
      context: context,
      child: ThemeSelectorModalWidget(
        currentMode: ref.read(themeNotifierProvider),
        onModeSelected: (mode) async {
          await themeNotifier.setThemeMode(mode);

          if (!context.mounted) return;

          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
    );
  }

  List<Widget> _buildSections(
    ColorScheme colorScheme,
    ThemeMode themeMode,
    UserEntity? user,
  ) {
    return [
      if (user != null)
        SettingsSectionWidget(
          title: 'Minha Conta',
          children: [
            SettingsTileWidget(
              icon: Icons.person_outline_rounded,
              title: 'Editar Perfil',
              onTap: () => AppRoutes.goToEditProfile(context),
            ),
          ],
        ),
      SettingsSectionWidget(
        title: 'Informações do Curso',
        children: [
          SettingsTileWidget(
            icon: Icons.list_alt_rounded,
            title: 'Disciplinas do Curso',
            onTap: () => AppRoutes.goToDisciplines(context),
          ),
          SettingsTileWidget(
            icon: Icons.info_outline_rounded,
            title: 'Sobre o Curso',
            onTap: () => AppRoutes.goToCourseDetails(context),
          ),
        ],
      ),
      SettingsSectionWidget(
        title: 'Organização',
        children: [
          SettingsTileWidget(
            icon: Icons.category_rounded,
            title: 'Categorias',
            onTap: () => AppRoutes.goToCategories(context),
          ),
          SettingsTileWidget(
            icon: Icons.category_rounded,
            title: 'Tags',
            onTap: () => AppRoutes.goToTags(context),
          ),
        ],
      ),
      SettingsSectionWidget(
        title: 'Preferências',
        children: [
          SettingsTileWidget(
            icon: Icons.palette_rounded,
            title: 'Tema do Aplicativo',
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
                themeMode.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      SettingsSectionWidget(
        title: 'Suporte',
        children: [
          SettingsTileWidget(
            icon: Icons.info_rounded,
            title: 'Sobre o Academic Planner',
            onTap: () => AppRoutes.goToAbout(context),
          ),
        ],
      ),
      if (user != null)
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SettingsSectionWidget(
            title: 'Sessão e Segurança',
            children: [
              SettingsTileWidget(
                icon: Icons.logout_rounded,
                title: 'Sair da Conta',
                onTap: () async {
                  await LogoutConfirmationDialogWidget.show(context);
                },
              ),
              SettingsTileWidget(
                icon: Icons.no_accounts_rounded,
                title: 'Excluir Conta',
                color: colorScheme.error,
                onTap: () async {
                  await DeleteAccountConfirmationDialogWidget.show(context);
                },
              ),
            ],
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeState = ref.watch(themeNotifierProvider);
    final user = ref.watch(userNotifierProvider).value;

    final sections = _buildSections(colorScheme, themeState, user);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppBarWidget(title: 'Ajustes do App'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 140.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsProfileHeaderWidget(),
            const SizedBox(height: 32.0),
            Column(spacing: 36.0, children: sections),
          ],
        ),
      ),
    );
  }
}
