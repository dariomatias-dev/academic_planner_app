enum UserRole { admin, teacher, student }

class UserEntity {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.role = UserRole.student,
    required this.createdAt,
    required this.updatedAt,
  });
}
