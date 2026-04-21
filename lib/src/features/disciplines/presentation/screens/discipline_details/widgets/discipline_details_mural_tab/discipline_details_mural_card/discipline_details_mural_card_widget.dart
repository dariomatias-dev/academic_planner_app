import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/extensions/announcement_type_extension.dart';

import 'package:academic_planner/src/features/disciplines/domain/entities/announcement.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_mural_tab/discipline_details_mural_card/discipline_details_mural_card_poll_widget.dart';

class DisciplineDetailsMuralCardWidget extends StatelessWidget {
  final Announcement announcement;

  const DisciplineDetailsMuralCardWidget({
    super.key,
    required this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = announcement.type.color(colorScheme);

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(
          color: announcement.isHighlighted
              ? accentColor.withAlpha(80)
              : theme.dividerTheme.color ?? Colors.transparent,
          width: announcement.isHighlighted ? 1.5 : 1.0,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.onSurface.withAlpha(12),
            blurRadius: 24.0,
            offset: const Offset(0.0, 8.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            announcement.type.icon,
                            size: 14.0,
                            color: accentColor,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            announcement.type.label,
                            style: GoogleFonts.plusJakartaSans(
                              color: accentColor,
                              fontSize: 9.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (announcement.isHighlighted)
                      Icon(
                        Icons.push_pin_rounded,
                        size: 16.0,
                        color: accentColor.withAlpha(180),
                      ),
                    const SizedBox(width: 8.0),
                    Text(
                      DateFormat('dd MMM').format(announcement.createdAt),
                      style: GoogleFonts.plusJakartaSans(
                        color: colorScheme.onSurface.withAlpha(100),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  announcement.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w900,
                    fontSize: 18.0,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  announcement.message,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    color: colorScheme.onSurface.withAlpha(160),
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (announcement.eventDate != null) ...<Widget>[
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: colorScheme.onSurface.withAlpha(10),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 18.0,
                          color: accentColor,
                        ),
                        const SizedBox(width: 12.0),
                        Text(
                          DateFormat(
                            "'Agendado para:' dd 'de' MMMM",
                          ).format(announcement.eventDate!),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface.withAlpha(200),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (announcement.poll != null) ...<Widget>[
                  const SizedBox(height: 24.0),
                  DisciplineDetailsMuralCardPollWidget(
                    poll: announcement.poll!,
                    accentColor: accentColor,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
