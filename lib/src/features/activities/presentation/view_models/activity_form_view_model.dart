import 'dart:convert';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/domain/entities/discipline.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:logging/logging.dart';

class ActivityFormViewModel {
  ActivityFormViewModel(this._activityNotifier) {
    titleController.addListener(updateChangeTracker);
    notesController.addListener(updateChangeTracker);
    descriptionController.addListener(updateChangeTracker);
  }

  static final _log = Logger('activities.ActivityFormViewModel');

  final ActivityNotifier _activityNotifier;

  final titleController = TextEditingController();
  final notesController = TextEditingController();
  final descriptionController = QuillController.basic();

  final _disciplineNotifier = ValueNotifier<Discipline?>(null);
  final _dueDateNotifier = ValueNotifier<DateTime?>(null);
  final _statusNotifier = ValueNotifier<ActivityStatus>(ActivityStatus.draft);
  final _categoryNotifier = ValueNotifier<String?>(null);
  final _tagsNotifier = ValueNotifier<List<String>>([]);
  final _remindersNotifier = ValueNotifier<List<TimeOfDay>>([]);
  final _isLoadingNotifier = ValueNotifier<bool>(false);
  final _canSaveNotifier = ValueNotifier<bool>(false);

  ValueListenable<Discipline?> get discipline => _disciplineNotifier;
  ValueListenable<DateTime?> get dueDate => _dueDateNotifier;
  ValueListenable<ActivityStatus> get status => _statusNotifier;
  ValueListenable<String?> get category => _categoryNotifier;
  ValueListenable<List<String>> get tags => _tagsNotifier;
  ValueListenable<List<TimeOfDay>> get reminders => _remindersNotifier;
  ValueListenable<bool> get isLoading => _isLoadingNotifier;
  ValueListenable<bool> get canSave => _canSaveNotifier;

  Activity? _initialActivity;
  Activity? get initialActivity => _initialActivity;

  Future<Result<void>> load({
    required String? activityId,
    required int? initialDisciplineId,
  }) async {
    if (activityId == null) {
      _initNew(initialDisciplineId);

      return const Success(null);
    }

    _isLoadingNotifier.value = true;

    final result = await _activityNotifier.getById(activityId);

    _isLoadingNotifier.value = false;

    return result.fold(
      onSuccess: (activity) {
        if (activity != null) _loadFromActivity(activity);

        return const Success(null);
      },
      onFailure: Failure.new,
    );
  }

  Future<Result<void>> save() async {
    if (_initialActivity != null) {
      return _activityNotifier.edit(_buildUpdatedActivity());
    }

    final newActivity = _activityNotifier.createNew(
      title: titleController.text.trim(),
      description: _getEncodedDescription(),
      disciplineId: _disciplineNotifier.value!.id,
      tags: _tagsNotifier.value,
      reminders: _remindersNotifier.value,
      status: _statusNotifier.value,
      notes: notesController.text.trim(),
      dueDate: _dueDateNotifier.value,
      category: _categoryNotifier.value,
    );

    return _activityNotifier.add(newActivity);
  }

  void _initNew(int? initialDisciplineId) {
    if (initialDisciplineId != null) {
      _disciplineNotifier.value = adsDisciplines.where((d) {
        return d.id == initialDisciplineId;
      }).firstOrNull;
    }

    updateChangeTracker();
  }

  void _loadFromActivity(Activity activity) {
    _initialActivity = activity;
    titleController.text = activity.title;
    notesController.text = activity.notes ?? '';

    try {
      final doc = Document.fromJson(
        jsonDecode(activity.description) as List<dynamic>,
      );

      descriptionController.document = doc;
      descriptionController.updateSelection(
        const TextSelection.collapsed(offset: 0),
        ChangeSource.local,
      );

      FocusManager.instance.primaryFocus?.unfocus();
    } on Exception catch (err, stackTrace) {
      _log.severe('Failed to parse description', err, stackTrace);
    }

    _disciplineNotifier.value = adsDisciplines.where((d) {
      return d.id == activity.disciplineId;
    }).firstOrNull;
    _dueDateNotifier.value = activity.dueDate;
    _statusNotifier.value = activity.status;
    _categoryNotifier.value = activity.category;
    _tagsNotifier.value = List<String>.from(activity.tags);
    _remindersNotifier.value = List<TimeOfDay>.from(activity.reminders);

    updateChangeTracker();
  }

  Activity _buildUpdatedActivity() {
    return _initialActivity!.copyWith(
      title: titleController.text.trim(),
      description: _getEncodedDescription(),
      notes: notesController.text.trim(),
      disciplineId: _disciplineNotifier.value?.id,
      dueDate: _dueDateNotifier.value,
      category: _categoryNotifier.value,
      tags: _tagsNotifier.value,
      reminders: _remindersNotifier.value,
      status: _statusNotifier.value,
    );
  }

  String _getEncodedDescription() {
    return jsonEncode(descriptionController.document.toDelta().toJson());
  }

  void setDiscipline(Discipline? value) {
    _disciplineNotifier.value = value;

    updateChangeTracker();
  }

  void setStatus(ActivityStatus value) {
    _statusNotifier.value = value;

    updateChangeTracker();
  }

  void setCategory(String? value) {
    _categoryNotifier.value = value;

    updateChangeTracker();
  }

  void setDueDate(DateTime? value) {
    _dueDateNotifier.value = value;

    updateChangeTracker();
  }

  void toggleTag(String tag, {bool value = false}) {
    final current = List<String>.from(_tagsNotifier.value);

    value ? current.add(tag) : current.remove(tag);

    _tagsNotifier.value = current;

    updateChangeTracker();
  }

  void addReminder(TimeOfDay time) {
    if (_remindersNotifier.value.contains(time)) return;

    _remindersNotifier.value = [..._remindersNotifier.value, time];

    updateChangeTracker();
  }

  void removeReminder(TimeOfDay time) {
    final current = List<TimeOfDay>.from(_remindersNotifier.value)
      ..remove(time);

    _remindersNotifier.value = current;

    updateChangeTracker();
  }

  void updateChangeTracker() {
    _canSaveNotifier.value = hasChanges();
  }

  bool hasChanges() {
    if (_initialActivity == null) return true;

    final currentDescription = jsonEncode(
      descriptionController.document.toDelta().toJson(),
    );

    return titleController.text.trim() != _initialActivity!.title.trim() ||
        currentDescription != _initialActivity!.description ||
        notesController.text.trim() !=
            (_initialActivity!.notes?.trim() ?? '') ||
        _disciplineNotifier.value?.id != _initialActivity!.disciplineId ||
        !_isSameDay(_dueDateNotifier.value, _initialActivity!.dueDate) ||
        _statusNotifier.value != _initialActivity!.status ||
        _categoryNotifier.value != _initialActivity!.category ||
        !(_tagsNotifier.value.length == _initialActivity!.tags.length &&
            _tagsNotifier.value.every(
              (t) => _initialActivity!.tags.contains(t),
            )) ||
        !(_remindersNotifier.value.length ==
                _initialActivity!.reminders.length &&
            _remindersNotifier.value.every(
              (r) => _initialActivity!.reminders.contains(r),
            ));
  }

  bool _isSameDay(DateTime? d1, DateTime? d2) {
    if (d1 == null && d2 == null) return true;
    if (d1 == null || d2 == null) return false;

    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  void dispose() {
    titleController.dispose();
    notesController.dispose();
    descriptionController.dispose();
    _disciplineNotifier.dispose();
    _dueDateNotifier.dispose();
    _statusNotifier.dispose();
    _categoryNotifier.dispose();
    _tagsNotifier.dispose();
    _remindersNotifier.dispose();
    _isLoadingNotifier.dispose();
    _canSaveNotifier.dispose();
  }
}
