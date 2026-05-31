import 'dart:convert';

import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/core/services/shared_preferences_service.dart';

import 'package:academic_planner/src/features/tags/data/models/tag_model.dart';
import 'package:academic_planner/src/features/tags/domain/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final SharedPreferencesService prefs;

  static const _key = 'tags';

  TagRepositoryImpl(this.prefs);

  @override
  Future<Result<List<TagModel>>> getTags() async {
    try {
      final jsonString = prefs.getString(_key);

      if (jsonString.isEmpty) {
        return Success(_defaultTags());
      }

      final List decoded = jsonDecode(jsonString);

      return Success(decoded.builder((e, index) => TagModel.fromMap(e)));
    } catch (err) {
      return FailureResult(UnknownFailure(err.toString()));
    }
  }

  @override
  Future<Result<void>> saveTags(List<TagModel> tags) async {
    try {
      final encoded = jsonEncode(tags.builder((e, index) => e.toMap()));

      await prefs.setString(_key, encoded);

      return const Success(null);
    } catch (err) {
      return FailureResult(UnknownFailure(err.toString()));
    }
  }

  List<TagModel> _defaultTags() {
    return const <TagModel>[
      TagModel("Urgente"),
      TagModel("Teórica"),
      TagModel("Prática"),
      TagModel("Grupo"),
    ];
  }
}
