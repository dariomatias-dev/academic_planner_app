import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/calendar/presentation/view_models/agenda_state.dart';

class AgendaViewModel {
  AgendaState handleFetchSuccess(
    AgendaState currentState,
    List<Activity> activities,
  ) {
    return currentState.copyWith(
      activities: activities.filter((a) => a.dueDate != null),
    );
  }

  AgendaState handleDisplayDateChange(AgendaState currentState, DateTime date) {
    if (date.month != currentState.displayDate.month ||
        date.year != currentState.displayDate.year) {
      return currentState.copyWith(displayDate: date);
    }

    return currentState;
  }

  AgendaState handleSelectedDateChange(
    AgendaState currentState,
    DateTime date,
  ) {
    return currentState.copyWith(selectedDate: date);
  }
}
