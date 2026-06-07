import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.title,
    this.actions,
    this.showBackButton,
    this.backgroundColor,
  });

  final String? title;
  final List<Widget>? actions;
  final bool? showBackButton;
  final Color? backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canGoBack = Navigator.canPop(context);
    final displayBackButton = showBackButton ?? canGoBack;
    final bgColor = backgroundColor ?? colorScheme.surface;

    return AppBar(
      automaticallyImplyLeading: false,
      surfaceTintColor: bgColor,
      backgroundColor: bgColor,
      elevation: 0.0,
      titleSpacing: 0.0,
      toolbarHeight: preferredSize.height,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            if (displayBackButton)
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: BackIconButtonWidget(),
              ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: GoogleFonts.plusJakartaSans(
                        color: colorScheme.onSurface,
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
