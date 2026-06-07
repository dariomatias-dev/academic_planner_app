import 'package:academic_planner/src/shared/utils/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModalBottomSheetWidget extends StatelessWidget {
  const ModalBottomSheetWidget({required this.child, super.key, this.title});

  final String? title;
  final Widget child;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
  }) {
    return ModalBottomSheet.show<T>(
      context: context,
      child: ModalBottomSheetWidget(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.0,
            height: 4.0,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).dividerTheme.color ??
                  colorScheme.onSurface.withAlpha(30),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          if (title != null) ...[
            const SizedBox(height: 24.0),
            Text(
              title!,
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface,
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          const SizedBox(height: 20.0),
          Flexible(child: child),
        ],
      ),
    );
  }
}
