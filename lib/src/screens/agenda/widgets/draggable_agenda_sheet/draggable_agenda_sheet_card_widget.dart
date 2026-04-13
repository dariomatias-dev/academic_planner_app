import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/shared/models/agenda_entry_model.dart';

class DraggableAgendaSheetCardWidget extends StatelessWidget {
  final int index;
  final AgendaEntryModel entry;

  const DraggableAgendaSheetCardWidget({
    super.key,
    required this.index,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        height: 130.0,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: colorScheme.onSurface.withAlpha(15),
                      blurRadius: 24.0,
                      offset: const Offset(0.0, 8.0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border.all(
                        color: entry.color.withAlpha(14),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 4.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: entry.color,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                entry.typeLabel.toUpperCase(),
                                style: GoogleFonts.plusJakartaSans(
                                  color: entry.color,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                entry.title,
                                style: GoogleFonts.plusJakartaSans(
                                  color: colorScheme.onSurface,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    entry.icon,
                                    size: 14.0,
                                    color: colorScheme.onSurface.withAlpha(120),
                                  ),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    entry.subtitle,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: colorScheme.onSurface.withAlpha(
                                        160,
                                      ),
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (!entry.isAllDay) ...<Widget>[
                                    const SizedBox(width: 16.0),
                                    Icon(
                                      Icons.schedule_rounded,
                                      size: 16.0,
                                      color: colorScheme.onSurface.withAlpha(
                                        120,
                                      ),
                                    ),
                                    const SizedBox(width: 6.0),
                                    Text(
                                      DateFormat(
                                        'HH:mm',
                                      ).format(entry.startTime),
                                      style: GoogleFonts.plusJakartaSans(
                                        color: colorScheme.onSurface.withAlpha(
                                          160,
                                        ),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: colorScheme.onSurface.withAlpha(80),
                          size: 16.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 40.0,
              bottom: -10.0,
              child: Text(
                index.toString().padLeft(2, '0'),
                style: GoogleFonts.plusJakartaSans(
                  color: entry.color.withAlpha(18),
                  fontSize: 60.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
