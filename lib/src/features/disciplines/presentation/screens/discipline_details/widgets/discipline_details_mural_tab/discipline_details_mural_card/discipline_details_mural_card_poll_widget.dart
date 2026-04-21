import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/features/disciplines/domain/entities/announcement.dart';

class DisciplineDetailsMuralCardPollWidget extends StatefulWidget {
  final AnnouncementPoll poll;
  final Color accentColor;

  const DisciplineDetailsMuralCardPollWidget({
    super.key,
    required this.poll,
    required this.accentColor,
  });

  @override
  State<DisciplineDetailsMuralCardPollWidget> createState() =>
      _DisciplineDetailsMuralCardPollWidgetState();
}

class _DisciplineDetailsMuralCardPollWidgetState
    extends State<DisciplineDetailsMuralCardPollWidget> {
  final _selectedOptions = <String>{};

  void _handleOptionTap(String text) {
    if (widget.poll.hasVoted) return;

    setState(() {
      if (widget.poll.isMultiSelect) {
        if (_selectedOptions.contains(text)) {
          _selectedOptions.remove(text);
        } else {
          _selectedOptions.add(text);
        }
      } else {
        _selectedOptions.clear();
        _selectedOptions.add(text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalVotes = widget.poll.options.fold<int>(
      0,
      (sum, opt) => sum + opt.votes,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.bar_chart_rounded,
              size: 16.0,
              color: widget.accentColor.withAlpha(180),
            ),
            const SizedBox(width: 8.0),
            Text(
              widget.poll.hasVoted ? "RESULTADOS" : "VOTAÇÃO ABERTA",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.0,
                fontWeight: FontWeight.w900,
                color: widget.accentColor.withAlpha(180),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        ...widget.poll.options.map((option) {
          final percentage = totalVotes > 0 ? (option.votes / totalVotes) : 0.0;
          final isSelected = _selectedOptions.contains(option.text);

          return Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              color: widget.poll.hasVoted
                  ? theme.scaffoldBackgroundColor
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: widget.poll.hasVoted
                    ? Colors.transparent
                    : (isSelected
                          ? widget.accentColor
                          : colorScheme.onSurface.withAlpha(15)),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                children: <Widget>[
                  if (widget.poll.hasVoted)
                    FractionallySizedBox(
                      widthFactor: percentage,
                      child: Container(
                        height: 52.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              widget.accentColor.withAlpha(60),
                              widget.accentColor.withAlpha(20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  InkWell(
                    onTap: () => _handleOptionTap(option.text),
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      height: 52.0,
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        children: <Widget>[
                          if (!widget.poll.hasVoted) ...<Widget>[
                            Icon(
                              widget.poll.isMultiSelect
                                  ? (isSelected
                                        ? Icons.check_box_rounded
                                        : Icons.check_box_outline_blank_rounded)
                                  : (isSelected
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off_rounded),
                              size: 20.0,
                              color: isSelected
                                  ? widget.accentColor
                                  : widget.accentColor.withAlpha(120),
                            ),
                            const SizedBox(width: 12.0),
                          ],
                          Expanded(
                            child: Text(
                              option.text,
                              style: GoogleFonts.plusJakartaSans(
                                color: colorScheme.onSurface.withAlpha(
                                  (widget.poll.hasVoted || isSelected)
                                      ? 255
                                      : 140,
                                ),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.poll.hasVoted)
                            Text(
                              "${(percentage * 100).toInt()}%",
                              style: GoogleFonts.plusJakartaSans(
                                color: widget.accentColor,
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
