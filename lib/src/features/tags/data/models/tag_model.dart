class TagModel {
  final String name;

  const TagModel(this.name);

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(map['name'] as String);
  }
}
