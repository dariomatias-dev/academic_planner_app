import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';

import 'package:academic_planner/src/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:academic_planner/src/features/tags/domain/repositories/tag_repository.dart';

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final prefs = ref.read(sharedPreferencesServiceProvider);

  return TagRepositoryImpl(prefs);
});
