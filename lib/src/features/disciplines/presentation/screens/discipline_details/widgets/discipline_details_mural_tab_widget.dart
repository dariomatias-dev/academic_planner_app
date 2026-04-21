import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

enum AnnouncementType { info, reminder, poll, alert }

class PollOption {
  final String text;
  final int votes;

  PollOption({required this.text, required this.votes});
}

class PollData {
  final List<PollOption> options;
  final bool hasVoted;

  PollData({required this.options, this.hasVoted = false});
}

class Announcement {
  final String id;
  final String title;
  final String message;
  final AnnouncementType type;
  final DateTime createdAt;
  final PollData? poll;
  final DateTime? eventDate;
  final bool isHighlighted;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.poll,
    this.eventDate,
    this.isHighlighted = false,
  });
}

class DisciplineDetailsMuralTabWidget extends StatelessWidget {
  const DisciplineDetailsMuralTabWidget({super.key});

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final mockAnnouncements = <Announcement>[
      Announcement(
        id: '1',
        title: 'Alteração Crítica: Data da P2',
        message:
            'A prova que seria nesta sexta foi adiada para o dia 28/04 devido ao evento institucional no auditório central. O conteúdo permanece o mesmo.',
        type: AnnouncementType.alert,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isHighlighted: true,
      ),
      Announcement(
        id: '3',
        title: 'Enquete: Tema do Próximo Workshop',
        message:
            'Selecione abaixo qual macro-tema você prefere para o desenvolvimento prático da próxima semana.',
        type: AnnouncementType.poll,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        poll: PollData(
          hasVoted: false,
          options: <PollOption>[
            PollOption(text: 'Arquitetura de Microserviços', votes: 12),
            PollOption(text: 'Flutter Avançado & Performance', votes: 25),
          ],
        ),
      ),
      Announcement(
        id: '2',
        title: 'Monitoria Presencial',
        message:
            'O monitor estará disponível na sala 302 para tirar dúvidas sobre o projeto de interface e prototipagem.',
        type: AnnouncementType.reminder,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        eventDate: DateTime.now().add(const Duration(days: 2)),
      ),
      Announcement(
        id: '4',
        title: 'Material de Apoio: Unidade 2',
        message:
            'Os slides sobre Injeção de Dependência e Clean Architecture já foram anexados no repositório.',
        type: AnnouncementType.info,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        poll: PollData(
          hasVoted: true,
          options: <PollOption>[
            PollOption(text: 'Material completo', votes: 45),
            PollOption(text: 'Faltam exemplos práticos', votes: 5),
          ],
        ),
      ),
    ];

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 100.0),
        physics: const BouncingScrollPhysics(),
        itemCount: mockAnnouncements.length,
        itemBuilder: (context, index) =>
            MuralAnnouncementCardWidget(announcement: mockAnnouncements[index]),
      ),
    );
  }
}

class MuralAnnouncementCardWidget extends StatelessWidget {
  final Announcement announcement;

  const MuralAnnouncementCardWidget({super.key, required this.announcement});

  Color _getTypeColor(ColorScheme colorScheme) {
    return switch (announcement.type) {
      AnnouncementType.info => colorScheme.primary,
      AnnouncementType.reminder => colorScheme.secondary,
      AnnouncementType.poll => Colors.teal,
      AnnouncementType.alert => colorScheme.error,
    };
  }

  IconData _getTypeIcon() {
    return switch (announcement.type) {
      AnnouncementType.info => Icons.info_outline_rounded,
      AnnouncementType.reminder => Icons.event_note_rounded,
      AnnouncementType.poll => Icons.how_to_vote_rounded,
      AnnouncementType.alert => Icons.priority_high_rounded,
    };
  }

  String _getTypeLabel() {
    return switch (announcement.type) {
      AnnouncementType.info => "INFORMATIVO",
      AnnouncementType.reminder => "LEMBRETE",
      AnnouncementType.poll => "ENQUETE",
      AnnouncementType.alert => "ALERTA",
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = _getTypeColor(colorScheme);

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
                          Icon(_getTypeIcon(), size: 14.0, color: accentColor),
                          const SizedBox(width: 8.0),
                          Text(
                            _getTypeLabel(),
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
                if (announcement.eventDate != null) ...[
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
                if (announcement.poll != null) ...[
                  const SizedBox(height: 24.0),
                  _MuralPollWidget(
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

class _MuralPollWidget extends StatelessWidget {
  final PollData poll;
  final Color accentColor;

  const _MuralPollWidget({required this.poll, required this.accentColor});

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
              size: 16,
              color: accentColor.withAlpha(180),
            ),
            const SizedBox(width: 8),
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
                                fontSize: 13.5,
                                fontWeight: poll.hasVoted
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: colorScheme.onSurface.withAlpha(220),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (poll.hasVoted)
                            Text(
                              "${(percentage * 100).toInt()}%",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w900,
                                color: accentColor,
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
