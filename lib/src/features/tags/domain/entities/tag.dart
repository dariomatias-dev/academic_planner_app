class Tag {
  final String name;

  const Tag({required this.name});

  Tag copyWith({String? name}) {
    return Tag(name: name ?? this.name);
  }
}
