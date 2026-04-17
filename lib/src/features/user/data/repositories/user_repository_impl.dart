import 'package:academic_planner/src/features/user/data/models/user_model.dart';
import 'package:academic_planner/src/features/user/data/services/user_firestore_service.dart';
import 'package:academic_planner/src/features/user/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserFirestoreService _service;

  UserRepositoryImpl(this._service);

  @override
  Future<void> create(UserEntity user) async {
    final model = UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );

    await _service.saveUser(model);
  }

  @override
  Future<UserEntity?> getById(String uid) async {
    final doc = await _service.getUserDoc(uid);

    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }

    return null;
  }

  @override
  Future<void> update(UserEntity user) async {
    final model = UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );

    await _service.updateUser(model);
  }

  @override
  Future<void> delete(String uid) async {
    await _service.deleteUser(uid);
  }
}
