import 'package:academic_planner/src/features/tags/data/models/tag_model.dart';

abstract class TagRepository {
  Future<List<TagModel>> getTags();

  Future<void> saveTags(List<TagModel> tags);
}
