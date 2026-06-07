class Tag {
  const Tag({required this.name});

  final String name;

  Tag copyWith({String? name}) {
    return Tag(name: name ?? this.name);
  }
}
