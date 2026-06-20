import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';
import 'package:academic_planner/src/features/categories/data/data_source/category_local_datasource.dart';
import 'package:academic_planner/src/features/categories/data/repositories/category_repository_impl.dart';
import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:academic_planner/src/features/categories/domain/repositories/category_repository.dart';
import 'package:academic_planner/src/features/categories/presentation/providers/category_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryDataSourceProvider = Provider<CategoryLocalDataSource>((ref) {
  final prefs = ref.read(sharedPreferencesServiceProvider);

  return CategoryLocalDataSource(prefs);
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final datasource = ref.watch(categoryDataSourceProvider);

  return CategoryRepositoryImpl(datasource);
});

final categoryNotifierProvider =
    AsyncNotifierProvider<CategoryNotifier, List<Category>>(
      CategoryNotifier.new,
    );
