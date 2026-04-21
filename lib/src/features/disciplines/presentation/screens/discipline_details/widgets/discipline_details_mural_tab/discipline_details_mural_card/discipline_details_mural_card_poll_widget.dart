import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/features/disciplines/domain/entities/announcement.dart';

class DisciplineDetailsMuralCardPollWidget extends StatelessWidget {
  final AnnouncementPoll poll;
  final Color accentColor;

  const DisciplineDetailsMuralCardPollWidget({
    super.key,
    required this.poll,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalVotes = poll.options.fold<int>(0, (sum, opt) => sum + opt.votes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.bar_chart_rounded,
              size: 16.0,
              color: accentColor.withAlpha(180),
            ),
            const SizedBox(width: 8.0),
            Text(
              poll.hasVoted ? "RESULTADOS PARCIAIS" : "VOTAÇÃO DISPONÍVEL",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.0,
                fontWeight: FontWeight.w900,
                color: accentColor.withAlpha(180),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        ...poll.options.map((option) {
          final percentage = totalVotes > 0 ? (option.votes / totalVotes) : 0.0;

          return Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              color: poll.hasVoted
                  ? theme.scaffoldBackgroundColor
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: poll.hasVoted
                    ? Colors.transparent
                    : colorScheme.onSurface.withAlpha(15),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                children: <Widget>[
                  if (poll.hasVoted)
                    FractionallySizedBox(
                      widthFactor: percentage,
                      child: Container(
                        height: 52.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              accentColor.withAlpha(60),
                              accentColor.withAlpha(20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  InkWell(
                    onTap: poll.hasVoted ? null : () {},
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      height: 52.0,
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        children: <Widget>[
                          if (!poll.hasVoted)
                            Icon(
                              Icons.radio_button_off_rounded,
                              size: 20.0,
                              color: accentColor.withAlpha(120),
                            ),
                          if (!poll.hasVoted) const SizedBox(width: 12.0),
                          Expanded(
                            child: Text(
                              option.text,
                              style: GoogleFonts.plusJakartaSans(
                                color: colorScheme.onSurface.withAlpha(220),
                                fontSize: 13.5,
                                fontWeight: poll.hasVoted
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (poll.hasVoted)
                            Text(
                              "${(percentage * 100).toInt()}%",
                              style: GoogleFonts.plusJakartaSans(
                                color: accentColor,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
