import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_app_bar_actions_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_description_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_discipline_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_due_date_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_header_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_notes_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_reminders_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_section_title_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_status_selector_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_tags_widget.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/metadata_card/metadata_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityDetailsScreen extends ConsumerStatefulWidget {
  const ActivityDetailsScreen({required this.activityId, super.key});

  final String activityId;

  @override
  ConsumerState<ActivityDetailsScreen> createState() =>
      _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends ConsumerState<ActivityDetailsScreen> {
  Activity? _activity;
  ActivityStatus? _originalStatus;
  ActivityStatus? _currentStatus;
  bool _isLoading = true;

  bool get _hasStatusChanged {
    return _originalStatus != _currentStatus;
  }

  Future<void> _fetchActivity() async {
    setState(() {
      _isLoading = true;
    });

    final activityNotifier = ref.read(activityNotifierProvider.notifier);
    final result = await activityNotifier.getById(widget.activityId);

    await result.fold(
      onSuccess: (activity) {
        setState(() {
          _activity = activity;
          _originalStatus = activity?.status;
          _currentStatus = activity?.status;
          _isLoading = false;
        });
      },
      onFailure: (failure) async {
        setState(() => _isLoading = false);

        await Fluttertoast.showToast(msg: 'Erro ao carregar atividade');
      },
    );
  }

  Future<void> _saveStatus() async {
    if (_activity == null || _currentStatus == null) return;

    final notifier = ref.read(activityNotifierProvider.notifier);

    final updatedActivity = _activity!.copyWith(status: _currentStatus);

    final result = await notifier.edit(updatedActivity);

    result.when(
      onSuccess: (_) async {
        setState(() {
          _activity = updatedActivity;
          _originalStatus = _currentStatus;
        });

        await Fluttertoast.showToast(msg: 'Status atualizado com sucesso');
      },
      onFailure: (failure) async {
        await Fluttertoast.showToast(msg: 'Erro ao salvar alterações');
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchActivity());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: _activity?.title ?? 'Detalhes',
        actions: [
          if (!_isLoading && _activity != null)
            ActivityDetailsAppBarActionsWidget(
              activity: _activity!,
              hasStatusChanged: _hasStatusChanged,
              onSaveStatus: _saveStatus,
              onEdited: _fetchActivity,
            ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return const LoadingStateWidget();
          }

          if (_activity == null) {
            return EmptyStateWidget(
              icon: Icons.description_outlined,
              title: 'Atividade não encontrada',
              description:
                  'Não foi possível carregar os detalhes desta atividade.',
              actionLabel: 'Tentar novamente',
              onActionPressed: _fetchActivity,
            );
          }

          final discipline = adsDisciplines.where((d) {
            return d.id == _activity!.disciplineId;
          }).firstOrNull;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActivityDetailsHeaderWidget(
                  category: _activity!.category,
                  status: _currentStatus,
                ),
                const SizedBox(height: 16.0),
                Text(
                  _activity!.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    height: 1.2,
                  ),
                ),
                if (_activity!.dueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: ActivityDetailsDueDateWidget(
                      dueDate: _activity!.dueDate,
                    ),
                  ),
                const SizedBox(height: 32.0),
                const ActivityDetailsSectionTitleWidget(
                  title: 'Alterar Status',
                ),
                ActivityDetailsStatusSelectorWidget(
                  currentStatus: _currentStatus,
                  onChanged: (status) {
                    setState(() {
                      _currentStatus = status;
                    });
                  },
                ),
                const SizedBox(height: 32.0),
                const ActivityDetailsSectionTitleWidget(title: 'Descrição'),
                ActivityDetailsDescriptionWidget(
                  description: _activity!.description,
                ),
                if (discipline != null) ...[
                  const SizedBox(height: 32.0),
                  const ActivityDetailsSectionTitleWidget(title: 'Disciplina'),
                  ActivityDetailsDisciplineWidget(discipline: discipline),
                ],
                if (_activity!.tags.isNotEmpty) ...[
                  const SizedBox(height: 32.0),
                  const ActivityDetailsSectionTitleWidget(title: 'Tags'),
                  ActivityDetailsTagsWidget(tags: _activity!.tags),
                ],
                if (_activity!.reminders.isNotEmpty) ...[
                  const SizedBox(height: 32.0),
                  const ActivityDetailsSectionTitleWidget(title: 'Lembretes'),
                  ActivityDetailsRemindersWidget(
                    reminders: _activity!.reminders,
                  ),
                ],
                if (_activity!.notes != null &&
                    _activity!.notes!.isNotEmpty) ...[
                  const SizedBox(height: 32.0),
                  const ActivityDetailsSectionTitleWidget(title: 'Anotações'),
                  ActivityDetailsNotesWidget(notes: _activity!.notes!),
                ],
                const SizedBox(height: 48.0),
                const ActivityDetailsSectionTitleWidget(title: 'Cronologia'),
                MetadataCardWidget(
                  createdAt: _activity!.createdAt,
                  updatedAt: _activity!.updatedAt,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
