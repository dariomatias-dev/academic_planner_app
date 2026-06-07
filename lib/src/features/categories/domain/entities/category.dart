class Category {
  const Category({required this.name});

  final String name;

  Category copyWith({String? name}) {
    return Category(name: name ?? this.name);
  }
}
