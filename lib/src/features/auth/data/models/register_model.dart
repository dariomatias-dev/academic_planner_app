import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';

class RegisterModel {
  RegisterModel({
    required this.name,
    required this.email,
    required this.password,
  });

  factory RegisterModel.fromEntity(RegisterEntity entity) {
    return RegisterModel(
      name: entity.name,
      email: entity.email,
      password: entity.password,
    );
  }

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  final String name;
  final String email;
  final String password;

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'password': password};
  }
}
