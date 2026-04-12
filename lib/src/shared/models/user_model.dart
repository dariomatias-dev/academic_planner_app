class UserModel {
  final String id;
  final String name;
  final String email;
  final String course;
  final String campus;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.course,
    required this.campus,
    this.isVerified = false,
  });
}
