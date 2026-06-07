import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/features/users/data/models/user_model.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreService {
  UserFirestoreService(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference get _usersRef => _firestore.collection('users');

  Future<void> saveUser(UserModel user) async {
    await _usersRef.doc(user.id).set(user.toMap());
  }

  Future<List<UserModel>> getUsers({String? query, UserRole? role}) async {
    Query firestoreQuery = _usersRef;

    if (role != null) {
      firestoreQuery = firestoreQuery.where('role', isEqualTo: role.name);
    }

    if (query != null && query.isNotEmpty) {
      firestoreQuery = firestoreQuery.orderBy('name').startAt([query]).endAt([
        '$query\uf8ff',
      ]);
    }

    final snapshot = await firestoreQuery.get();

    return snapshot.docs.builder((doc, index) {
      return UserModel.fromMap(doc.data()! as Map<String, dynamic>);
    });
  }

  Future<DocumentSnapshot> getUserDoc(String uid) async {
    return _usersRef.doc(uid).get();
  }

  Future<void> updateUser(UserModel user) async {
    await _usersRef.doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String uid) async {
    await _usersRef.doc(uid).delete();
  }
}
