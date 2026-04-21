import 'package:flutter/material.dart';

import 'package:academic_planner/src/features/disciplines/domain/entities/announcement.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_mural_tab/discipline_details_mural_card/discipline_details_mural_card_widget.dart';

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
        title: 'Enquete: Preferência de Workshop',
        message:
            'Selecione os temas que você tem interesse. Você pode marcar mais de uma opção.',
        type: AnnouncementType.poll,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        poll: AnnouncementPoll(
          hasVoted: false,
          isMultiSelect: true,
          options: <AnnouncementPollOption>[
            AnnouncementPollOption(text: 'Clean Architecture', votes: 12),
            AnnouncementPollOption(
              text: 'Riverpod State Management',
              votes: 25,
            ),
            AnnouncementPollOption(text: 'CI/CD com GitHub Actions', votes: 8),
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
        poll: AnnouncementPoll(
          hasVoted: true,
          options: <AnnouncementPollOption>[
            AnnouncementPollOption(text: 'Material completo', votes: 45),
            AnnouncementPollOption(text: 'Faltam exemplos práticos', votes: 5),
          ],
        ),
      ),
      Announcement(
        id: '5',
        title: 'Confirmação de Presença',
        message: 'Você irá participar da apresentação final?',
        type: AnnouncementType.poll,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        poll: AnnouncementPoll(
          options: <AnnouncementPollOption>[
            AnnouncementPollOption(text: 'Sim', votes: 10),
            AnnouncementPollOption(text: 'Não', votes: 3),
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
        itemBuilder: (context, index) {
          return DisciplineDetailsMuralCardWidget(
            announcement: mockAnnouncements[index],
          );
        },
      ),
    );
  }
}
