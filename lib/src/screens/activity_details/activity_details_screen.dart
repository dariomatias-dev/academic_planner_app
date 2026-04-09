import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:academic_planner/src/controllers/activity_controller.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/activity_status_extension.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/screens/activity_details/widgets/activity_details_description_widget.dart';
import 'package:academic_planner/src/screens/activity_details/widgets/activity_details_discipline_widget.dart';
import 'package:academic_planner/src/screens/activity_details/widgets/activity_details_due_date_widget.dart';
import 'package:academic_planner/src/screens/activity_details/widgets/activity_details_menu_widget.dart';

import 'package:academic_planner/src/shared/utils/handle_activity_deletion.dart';
import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/empty_state_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/selectable_chip_widget.dart';

class ActivityDetailsScreen extends StatefulWidget {
  final String activityId;

  const ActivityDetailsScreen({super.key, required this.activityId});

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  late final _controller = context.read<ActivityController>();

  ActivityModel? _activity;
  ActivityStatus? _originalStatus;
  ActivityStatus? _currentStatus;
  bool _isLoading = true;

  bool get _hasStatusChanged => _originalStatus != _currentStatus;

  Future<void> _fetchActivity() async {
    setState(() => _isLoading = true);

    final result = await _controller.getActivityById(widget.activityId);

    result.when(
      onSuccess: (activity) {
        setState(() {
          _activity = activity;
          _originalStatus = activity?.status;
          _currentStatus = activity?.status;
          _isLoading = false;
        });
      },
      onFailure: (failure) {
        setState(() => _isLoading = false);

        Fluttertoast.showToast(msg: "Erro ao carregar atividade");
      },
    );
  }

  Future<void> _saveStatus() async {
    if (_activity == null || _currentStatus == null) return;

    final updatedActivity = _activity!.copyWith(status: _currentStatus);

    final result = await _controller.editActivity(updatedActivity);

    result.when(
      onSuccess: (_) {
        setState(() {
          _activity = updatedActivity;
          _originalStatus = _currentStatus;
        });

        Fluttertoast.showToast(msg: "Status atualizado com sucesso");
      },
      onFailure: (failure) {
        Fluttertoast.showToast(msg: "Erro ao salvar alterações");
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _fetchActivity();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: _activity?.title ?? 'Detalhes',
        actions: <Widget>[
          if (!_isLoading && _activity != null) ...<Widget>[
            if (_hasStatusChanged)
              IconButtonWidget(
                icon: Icons.check_rounded,
                onPressed: _saveStatus,
                style: IconButtonStyle.primary,
              ),
            ActivityDetailsMenuWidget(
              onEdit: () async {
                final result = await AppRoutes.goToActivityForm(
                  context,
                  activityId: _activity!.id,
                );

                if (result ?? false) {
                  _fetchActivity();
                }
              },
              onDelete: () async {
                final result = await handleActivityDeletion(
                  context: context,
                  activity: _activity!,
                );

                if (result && context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 44.0,
                    height: 44.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.5,
                      color: colorScheme.primary,
                      backgroundColor: colorScheme.primary.withAlpha(30),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Buscando informações...",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface.withAlpha(180),
                    ),
                  ),
                ],
              ),
            );
          }

          if (_activity == null) {
            return EmptyStateWidget(
              icon: Icons.description_outlined,
              title: "Atividade não encontrada",
              description:
                  "Não foi possível carregar os detalhes desta atividade.",
              actionLabel: "Tentar novamente",
              onActionPressed: _fetchActivity,
            );
          }

          final discipline = adsDisciplines
              .where((d) => d.id == _activity!.disciplineId)
              .firstOrNull;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (_activity!.category != null) ...<Widget>[
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
                      (_currentStatus?.label ?? "Sem Status").toUpperCase(),
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
                  title: "Alterar Status",
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    spacing: 8.0,
                    children: ActivityStatus.values.builder((status, index) {
                      final isSelected = _currentStatus == status;

                      return SelectableChipWidget(
                        onTap: () => setState(() => _currentStatus = status),
                        label: status.label,
                        isSelected: isSelected,
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 32.0),
                const ActivityDetailsSectionTitleWidget(title: "Descrição"),
                ActivityDetailsDescriptionWidget(
                  description: _activity!.description,
                ),
                if (discipline != null) ...<Widget>[
                  const SizedBox(height: 32.0),
                  const ActivityDetailsSectionTitleWidget(title: "Disciplina"),
                  ActivityDetailsDisciplineWidget(discipline: discipline),
                ],
                if (_activity!.tags.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 32.0),
                  const ActivityDetailsSectionTitleWidget(title: "Tags"),
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
                          "#$tag",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface.withAlpha(180),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
                if (_activity!.reminders.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 32.0),
                  const ActivityDetailsSectionTitleWidget(title: "Lembretes"),
                  ..._activity!.reminders.map((time) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.notifications_active_outlined,
                            size: 20.0,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            time.format(context),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
                if (_activity!.notes != null &&
                    _activity!.notes!.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 32.0),
                  const ActivityDetailsSectionTitleWidget(title: "Anotações"),
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
                        fontSize: 15.0,
                        height: 1.5,
                        color: colorScheme.onSurface.withAlpha(200),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 48.0),
                const ActivityDetailsSectionTitleWidget(title: "Cronologia"),
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      _buildMetadataInfo(
                        context,
                        "Criada em",
                        _activity!.createdAt,
                        Icons.calendar_today_rounded,
                      ),
                      Container(
                        width: 1.0,
                        height: 40.0,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        color: colorScheme.primary.withAlpha(40),
                      ),
                      _buildMetadataInfo(
                        context,
                        "Atualizada",
                        _activity!.updatedAt,
                        Icons.auto_awesome_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetadataInfo(
    BuildContext context,
    String label,
    DateTime date,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20.0, color: colorScheme.primary),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary.withAlpha(180),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  DateFormat('dd/MM/yyyy').format(date),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityDetailsSectionTitleWidget extends StatelessWidget {
  final String title;

  const ActivityDetailsSectionTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11.0,
          fontWeight: FontWeight.w900,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
