import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';

class TagModel {
  final String name;

  const TagModel(this.name);

  Tag toEntity() => Tag(name: name);

  factory TagModel.fromEntity(Tag tag) => TagModel(tag.name);

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(map['name'] as String);
  }
}
