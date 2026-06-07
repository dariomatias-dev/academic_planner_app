enum UserRole { admin, teacher, student }

class UserEntity {
  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.role = UserRole.student,
  });

  final String id;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;
}
