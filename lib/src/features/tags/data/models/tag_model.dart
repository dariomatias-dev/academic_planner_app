import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';

class TagModel {
  const TagModel(this.name);

  factory TagModel.fromEntity(Tag tag) => TagModel(tag.name);

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(map['name'] as String);
  }

  final String name;

  Tag toEntity() => Tag(name: name);

  Map<String, dynamic> toMap() {
    return {'name': name};
  }
}
