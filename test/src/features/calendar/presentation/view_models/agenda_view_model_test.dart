import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/calendar/presentation/view_models/agenda_state.dart';
import 'package:academic_planner/src/features/calendar/presentation/view_models/agenda_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

Activity _activity({String id = '1', DateTime? dueDate}) => Activity(
  id: id,
  title: 'Title',
  description: 'Description',
  disciplineId: 1,
  tags: const [],
  reminders: const [],
  status: ActivityStatus.pending,
  dueDate: dueDate,
);

void main() {
  late AgendaViewModel viewModel;

  setUp(() {
    viewModel = AgendaViewModel();
  });

  group('handleFetchSuccess', () {
    test('keeps only activities with a non-null dueDate', () {
      final withDate = _activity(dueDate: DateTime(2026, 1, 10));
      final withoutDate = _activity(id: '2');

      final state = viewModel.handleFetchSuccess(AgendaState(), [
        withDate,
        withoutDate,
      ]);

      expect(state.activities, [withDate]);
    });

    test('preserves other fields from currentState', () {
      final display = DateTime(2026, 3);
      final selected = DateTime(2026, 3, 5);
      final currentState = AgendaState(
        displayDate: display,
        selectedDate: selected,
      );

      final state = viewModel.handleFetchSuccess(currentState, []);

      expect(state.displayDate, display);
      expect(state.selectedDate, selected);
      expect(state.activities, isEmpty);
    });
  });

  group('handleDisplayDateChange', () {
    test('different month → updates displayDate', () {
      final currentState = AgendaState(displayDate: DateTime(2026, 1, 15));

      final state = viewModel.handleDisplayDateChange(
        currentState,
        DateTime(2026, 2),
      );

      expect(state.displayDate, DateTime(2026, 2));
    });

    test('different year, same month → updates displayDate', () {
      final currentState = AgendaState(displayDate: DateTime(2026, 1, 15));

      final state = viewModel.handleDisplayDateChange(
        currentState,
        DateTime(2027, 1, 15),
      );

      expect(state.displayDate, DateTime(2027, 1, 15));
    });

    test('same month and year → returns currentState unchanged', () {
      final currentState = AgendaState(displayDate: DateTime(2026, 1, 15));

      final state = viewModel.handleDisplayDateChange(
        currentState,
        DateTime(2026, 1, 28),
      );

      expect(state, same(currentState));
    });
  });

  group('handleSelectedDateChange', () {
    test('always updates selectedDate', () {
      final currentState = AgendaState(selectedDate: DateTime(2026, 3));
      final newDate = DateTime(2026, 1, 2);

      final state = viewModel.handleSelectedDateChange(currentState, newDate);

      expect(state.selectedDate, newDate);
    });
  });
}
