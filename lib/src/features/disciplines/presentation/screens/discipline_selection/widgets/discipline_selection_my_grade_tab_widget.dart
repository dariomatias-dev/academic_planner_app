import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/features/disciplines/di/discipline_providers.dart';
import 'package:academic_planner/src/features/disciplines/presentation/widgets/discipline_card/discipline_card_widget.dart';
import 'package:academic_planner/src/features/disciplines/presentation/widgets/disciplines_summary/disciplines_summary_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisciplineSelectionMyGradeTabWidget extends ConsumerWidget {
  const DisciplineSelectionMyGradeTabWidget({
    required this.mainTabController,
    super.key,
  });

  final TabController mainTabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final notifier = ref.watch(userDisciplinesNotifierProvider);

    final selected = adsDisciplines.filter((d) => notifier.contains(d.id));

    if (selected.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.auto_stories_rounded,
        title: 'Sua grade está vazia',
        description:
            'Selecione as disciplinas que você está cursando para montar '
            'seu cronograma acadêmico.',
        actionLabel: 'Adicionar disciplinas',
        onActionPressed: () {
          mainTabController.animateTo(1);
        },
      );
    }

    final totalWorkload = selected.fold<int>(
      0,
      (sum, item) => sum + item.workload,
    );

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 40.0),
      itemCount: selected.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: DisciplinesSummaryWidget(
              count: selected.length,
              workload: totalWorkload,
            ),
          );
        }

        final discipline = selected[index - 1];

        return DisciplineCardWidget(
          index: index,
          discipline: discipline,
          onTap: () async {
            await ref
                .read(userDisciplinesNotifierProvider.notifier)
                .toggleDiscipline(discipline.id);
          },
          trailing: Icon(
            Icons.remove_circle_outline_rounded,
            color: colorScheme.primary,
            size: 24.0,
          ),
        );
      },
    );
  }
}
