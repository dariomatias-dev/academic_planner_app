import 'package:academic_planner/src/core/services/shared_preferences_service.dart';
import 'package:academic_planner/src/features/activities/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/categories/domain/repositories/category_repository.dart';
import 'package:academic_planner/src/features/notes/domain/repositories/note_repository.dart';
import 'package:academic_planner/src/features/tags/domain/repositories/tag_repository.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockNoteRepository extends Mock implements NoteRepository {}

class MockTagRepository extends Mock implements TagRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockSharedPreferencesService extends Mock
    implements SharedPreferencesService {}
