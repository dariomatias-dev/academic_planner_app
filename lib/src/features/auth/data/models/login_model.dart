import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';

class LoginModel {
  LoginModel({required this.email, required this.password});

  factory LoginModel.fromEntity(LoginEntity entity) {
    return LoginModel(email: entity.email, password: entity.password);
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  final String email;
  final String password;

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }
}
