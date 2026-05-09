import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/di/database_provider.dart';

import 'package:academic_planner/src/features/notes/data/data_source/note_local_datasource.dart';
import 'package:academic_planner/src/features/notes/data/repositories/note_repository_impl.dart';
import 'package:academic_planner/src/features/notes/domain/repositories/note_repository.dart';

final noteDatasourceProvider = Provider<NoteLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);

  return NoteLocalDataSource(db);
});

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final datasource = ref.watch(noteDatasourceProvider);

  return NoteRepositoryImpl(datasource);
});
