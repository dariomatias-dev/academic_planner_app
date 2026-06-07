import 'package:academic_planner/src/features/calendar/presentation/providers/agenda_notifier.dart';
import 'package:academic_planner/src/features/calendar/presentation/view_models/agenda_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final agendaNotifierProvider =
    AsyncNotifierProvider<AgendaNotifier, AgendaState>(AgendaNotifier.new);
