class Category {
  final String name;

  const Category({required this.name});

  Category copyWith({String? name}) {
    return Category(name: name ?? this.name);
  }
}
