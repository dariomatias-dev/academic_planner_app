class CategoryModel {
  final String name;

  const CategoryModel(this.name);

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(map['name'] as String);
  }
}
