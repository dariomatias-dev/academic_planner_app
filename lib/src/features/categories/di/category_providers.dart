import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';

import 'package:academic_planner/src/features/categories/data/repositories/category_repository_impl.dart';
import 'package:academic_planner/src/features/categories/domain/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final prefs = ref.read(sharedPreferencesServiceProvider);

  return CategoryRepositoryImpl(prefs);
});
