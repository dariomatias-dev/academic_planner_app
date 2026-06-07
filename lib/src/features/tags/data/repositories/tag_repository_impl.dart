import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/result/exception_mapper.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/tags/data/data_source/tag_local_datasource.dart';
import 'package:academic_planner/src/features/tags/data/models/tag_model.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/domain/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  TagRepositoryImpl(this.datasource);

  final TagLocalDataSource datasource;

  static const _defaultTags = <Tag>[
    Tag(name: 'Urgente'),
    Tag(name: 'Teórica'),
    Tag(name: 'Prática'),
    Tag(name: 'Grupo'),
  ];

  @override
  Future<Result<List<Tag>>> getTags() async {
    try {
      final data = datasource.getAll();

      if (data.isEmpty) {
        await datasource.saveAll(
          _defaultTags.builder(
            (e, _) => TagModel.fromEntity(e).toMap(),
          ),
        );

        return const Success(_defaultTags);
      }

      return Success(
        data.builder((e, index) => TagModel.fromMap(e).toEntity()),
      );
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapDatabase(err));
    }
  }

  @override
  Future<Result<void>> saveTags(List<Tag> tags) async {
    try {
      await datasource.saveAll(
        tags.builder((e, index) => TagModel.fromEntity(e).toMap()),
      );

      return const Success(null);
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapDatabase(err));
    }
  }
}
