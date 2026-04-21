import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
    required super.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final created = map['created_at'];
    final updated = map['updated_at'];

    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: _roleFromString(map['role']),
      createdAt: created is Timestamp ? created.toDate() : DateTime.now(),
      updatedAt: updated is Timestamp ? updated.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  static UserRole _roleFromString(dynamic value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'teacher':
        return UserRole.teacher;
      default:
        return UserRole.student;
    }
  }
}
