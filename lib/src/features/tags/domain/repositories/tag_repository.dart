import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/tags/data/models/tag_model.dart';

abstract class TagRepository {
  Future<Result<List<TagModel>>> getTags();

  Future<Result<void>> saveTags(List<TagModel> tags);
}
