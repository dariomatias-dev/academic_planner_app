import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:academic_planner/src/features/users/data/models/user_model.dart';

class UserFirestoreService {
  UserFirestoreService(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference get _usersRef => _firestore.collection('users');

  Future<void> saveUser(UserModel user) async {
    await _usersRef.doc(user.id).set(user.toMap());
  }

  Future<DocumentSnapshot> getUserDoc(String uid) async {
    return await _usersRef.doc(uid).get();
  }

  Future<void> updateUser(UserModel user) async {
    await _usersRef.doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String uid) async {
    await _usersRef.doc(uid).delete();
  }
}
