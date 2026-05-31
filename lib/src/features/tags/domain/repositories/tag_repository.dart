import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';

abstract class TagRepository {
  Future<Result<List<Tag>>> getTags();

  Future<Result<void>> saveTags(List<Tag> tags);
}
