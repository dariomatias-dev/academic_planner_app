import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/activity_form_category_selector_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/activity_form_status_selector_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/activity_form_tag_selector_widget.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/features/disciplines/data/models/discipline_model.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityFormClassificationSectionWidget extends ConsumerWidget {
  const ActivityFormClassificationSectionWidget({
    required this.discipline,
    required this.onDisciplineSelected,
    required this.status,
    required this.onStatusSelected,
    required this.category,
    required this.onCategorySelected,
    required this.onCreateCategory,
    required this.tags,
    required this.onTagToggled,
    required this.onCreateTag,
    super.key,
  });

  final ValueListenable<DisciplineModel?> discipline;
  final void Function(DisciplineModel? value) onDisciplineSelected;
  final ValueListenable<ActivityStatus> status;
  final void Function(ActivityStatus value) onStatusSelected;
  final ValueListenable<String?> category;
  final void Function(String? value) onCategorySelected;
  final VoidCallback onCreateCategory;
  final ValueListenable<List<String>> tags;
  final void Function(String, {bool value}) onTagToggled;
  final VoidCallback onCreateTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories =
        ref.watch(categoriesNotifierProvider).asData?.value ?? [];
    final availableTags = ref.watch(tagNotifierProvider).asData?.value ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormSectionTitleWidget(title: 'Classificação'),
        ValueListenableBuilder<DisciplineModel?>(
          valueListenable: discipline,
          builder: (context, value, _) {
            return DisciplinePickerFieldWidget(
              selectedDiscipline: value,
              isRequired: true,
              onSelected: onDisciplineSelected,
            );
          },
        ),
        const SizedBox(height: 20.0),
        ValueListenableBuilder<ActivityStatus>(
          valueListenable: status,
          builder: (context, value, _) {
            return ActivityFormStatusSelectorWidget(
              selectedStatus: value,
              onSelect: onStatusSelected,
            );
          },
        ),
        const SizedBox(height: 20.0),
        ValueListenableBuilder<String?>(
          valueListenable: category,
          builder: (context, selectedCategory, _) {
            return ActivityFormCategorySelectorWidget(
              categories: categories.builder((c, _) => c.name),
              selectedCategory: selectedCategory,
              onSelect: onCategorySelected,
              onCreate: onCreateCategory,
            );
          },
        ),
        const SizedBox(height: 20.0),
        ValueListenableBuilder<List<String>>(
          valueListenable: tags,
          builder: (context, selected, _) {
            return ActivityFormTagSelectorWidget(
              availableTags: availableTags.builder((t, _) => t.name),
              selectedTags: selected,
              onToggle: onTagToggled,
              onCreate: onCreateTag,
            );
          },
        ),
      ],
    );
  }
}
