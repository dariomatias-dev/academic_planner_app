import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/tags/data/data_source/tag_local_datasource.dart';
import 'package:academic_planner/src/features/tags/data/models/tag_model.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/domain/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final TagLocalDataSource datasource;

  static const _defaultTags = <Tag>[
    Tag(name: 'Urgente'),
    Tag(name: 'Teórica'),
    Tag(name: 'Prática'),
    Tag(name: 'Grupo'),
  ];

  TagRepositoryImpl(this.datasource);

  @override
  Future<Result<List<Tag>>> getTags() async {
    try {
      final data = datasource.getAll();

      if (data.isEmpty) return const Success(_defaultTags);

      return Success(
        data.builder((e, index) => TagModel.fromMap(e).toEntity()),
      );
    } catch (err) {
      return FailureResult(UnknownFailure(err.toString()));
    }
  }

  @override
  Future<Result<void>> saveTags(List<Tag> tags) async {
    try {
      await datasource.saveAll(
        tags.builder((e, index) => TagModel.fromEntity(e).toMap()),
      );

      return const Success(null);
    } catch (err) {
      return FailureResult(UnknownFailure(err.toString()));
    }
  }
}
