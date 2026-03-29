import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_buttons.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? label;
  final String? title;
  final List<Widget>? actions;
  final bool? showBackButton;

  const AppBarWidget({
    super.key,
    this.label,
    this.title,
    this.actions,
    this.showBackButton,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.canPop(context);
    final displayBackButton = showBackButton ?? canGoBack;

    return AppBar(
      automaticallyImplyLeading: false,
      surfaceTintColor: AppColors.white,
      backgroundColor: AppColors.white,
      elevation: 0.0,
      titleSpacing: 0.0,
      toolbarHeight: preferredSize.height,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (displayBackButton)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: BackIconButtonWidget(),
              ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (label != null)
                    Text(
                      label!.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.accent,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  if (title != null)
                    Text(
                      title!,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textMain,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                ],
              ),
            ),
            if (actions != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!.separated(
                  () => const SizedBox(width: 8.0),
                  (action, index) => action,
                ),
              ),
          ],
        ),
      ),
      centerTitle: false,
    );
  }
}
