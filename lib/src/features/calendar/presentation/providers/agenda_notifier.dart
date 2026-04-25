import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/calendar/presentation/view_models/agenda_state.dart';
import 'package:academic_planner/src/features/calendar/presentation/view_models/agenda_view_model.dart';

class AgendaNotifier extends AsyncNotifier<AgendaState> {
  late final AgendaViewModel _viewModel;

  @override
  FutureOr<AgendaState> build() async {
    _viewModel = AgendaViewModel();

    ref.listen(activityNotifierProvider, (_, _) {
      if (state is! AsyncLoading) {
        Future.microtask(() {
          fetchData(filter: state.value?.filter);
        });
      }
    });

    return _fetchInitialData();
  }

  Future<AgendaState> _fetchInitialData() async {
    final activityNotifier = ref.read(activityNotifierProvider.notifier);
    final result = await activityNotifier.getAll();

    return result.fold(
      onSuccess: (activities) {
        return _viewModel.handleFetchSuccess(AgendaState(), activities);
      },
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> fetchData({ActivityFilter? filter}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final activityNotifier = ref.read(activityNotifierProvider.notifier);
      final result = await activityNotifier.getAll(filter: filter);

      return result.fold(
        onSuccess: (activities) {
          final currentState = state.value ?? AgendaState();

          return _viewModel.handleFetchSuccess(
            currentState.copyWith(filter: filter),
            activities,
          );
        },
        onFailure: (failure) => throw failure,
      );
    });
  }

  void updateDisplayDate(DateTime date) {
    final currentState = state.value;

    if (currentState != null) {
      state = AsyncData(_viewModel.handleDisplayDateChange(currentState, date));
    }
  }

  void updateSelectedDate(DateTime date) {
    final currentState = state.value;

    if (currentState != null) {
      state = AsyncData(
        _viewModel.handleSelectedDateChange(currentState, date),
      );
    }
  }

  void clearFilter() {
    final currentState = state.value;

    if (currentState != null) {
      state = AsyncData(currentState.copyWith(clearFilter: true));
    }
  }
}
