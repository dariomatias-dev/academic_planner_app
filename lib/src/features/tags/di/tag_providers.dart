import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';
import 'package:academic_planner/src/features/tags/data/data_source/tag_local_datasource.dart';
import 'package:academic_planner/src/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/domain/repositories/tag_repository.dart';
import 'package:academic_planner/src/features/tags/presentation/providers/tag_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tagDataSourceProvider = Provider<TagLocalDataSource>((ref) {
  final prefs = ref.read(sharedPreferencesServiceProvider);

  return TagLocalDataSource(prefs);
});

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final datasource = ref.watch(tagDataSourceProvider);

  return TagRepositoryImpl(datasource);
});

final tagNotifierProvider = AsyncNotifierProvider<TagNotifier, List<Tag>>(() {
  return TagNotifier();
});
