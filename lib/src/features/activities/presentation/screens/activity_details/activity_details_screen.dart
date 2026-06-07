import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/activity_status_extension.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/actions/delete_activity_flow.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_description_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_discipline_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_due_date_widget.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/metadata_card/metadata_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/popup_menu/popup_menu.dart';
import 'package:academic_planner/src/shared/widgets/selectable_chip_widget.dart';
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
          if (!_isLoading && _activity != null) ...[
            if (_hasStatusChanged)
              IconButtonWidget(
                icon: Icons.check_rounded,
                onPressed: _saveStatus,
                style: IconButtonStyle.primary,
              ),
            PopupMenuWidget(
              items: [
                PopupMenuActions.edit(
                  onTap: () async {
                    final result = await AppRoutes.goToActivityForm(
                      context,
                      activityId: _activity!.id,
                    );

                    if (result ?? false) await _fetchActivity();
                  },
                ),
                PopupMenuActions.delete(
                  onTap: () async {
                    final result = await deleteActivityFlow(
                      context: context,
                      ref: ref,
                      activity: _activity!,
                    );

                    if (result && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  color: colorScheme.error,
                ),
              ],
            ),
          ],
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
                Row(
                  children: [
                    if (_activity!.category != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withAlpha(25),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          _activity!.category!.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            color: colorScheme.primary,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                    ],
                    Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color:
                            _currentStatus?.color(colorScheme) ??
                            colorScheme.onSurface.withAlpha(80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      (_currentStatus?.label ?? 'Sem Status').toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        color: colorScheme.onSurface.withAlpha(150),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    spacing: 8.0,
                    children: ActivityStatus.values.builder((status, index) {
                      final isSelected = _currentStatus == status;

                      return SelectableChipWidget(
                        onTap: () {
                          setState(() {
                            _currentStatus = status;
                          });
                        },
                        label: status.label,
                        isSelected: isSelected,
                      );
                    }),
                  ),
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
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _activity!.tags.builder((tag, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color:
                                theme.dividerTheme.color ?? Colors.transparent,
                          ),
                        ),
                        child: Text(
                          '#$tag',
                          style: GoogleFonts.plusJakartaSans(
                            color: colorScheme.onSurface.withAlpha(180),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
                if (_activity!.reminders.isNotEmpty) ...[
                  const SizedBox(height: 32.0),
                  const ActivityDetailsSectionTitleWidget(title: 'Lembretes'),
                  ..._activity!.reminders.map((time) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications_active_outlined,
                            size: 20.0,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            time.format(context),
                            style: GoogleFonts.plusJakartaSans(
                              color: colorScheme.onSurface,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
                if (_activity!.notes != null &&
                    _activity!.notes!.isNotEmpty) ...[
                  const SizedBox(height: 32.0),
                  const ActivityDetailsSectionTitleWidget(title: 'Anotações'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(15),
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: Colors.amber.withAlpha(30)),
                    ),
                    child: Text(
                      _activity!.notes!,
                      style: GoogleFonts.plusJakartaSans(
                        color: colorScheme.onSurface.withAlpha(200),
                        fontSize: 15.0,
                        height: 1.5,
                      ),
                    ),
                  ),
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

class ActivityDetailsSectionTitleWidget extends StatelessWidget {
  const ActivityDetailsSectionTitleWidget({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 11.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
