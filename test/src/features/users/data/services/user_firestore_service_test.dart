import 'package:academic_planner/src/features/users/data/models/user_model.dart';
import 'package:academic_planner/src/features/users/data/services/user_firestore_service.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _rawUser({
  required String id,
  required String name,
  UserRole role = UserRole.student,
}) {
  return {
    'id': id,
    'email': '$id@example.com',
    'name': name,
    'role': role.name,
    'created_at': Timestamp.fromDate(DateTime.parse('2024-01-01T00:00:00.000')),
    'updated_at': Timestamp.fromDate(DateTime.parse('2024-01-01T00:00:00.000')),
  };
}

UserModel _userModel({String id = 'uid-1', String name = 'Alice'}) => UserModel(
  id: id,
  email: 'a@b.com',
  name: name,
  role: UserRole.student,
  createdAt: DateTime.parse('2024-01-01T00:00:00.000'),
  updatedAt: DateTime.parse('2024-01-01T00:00:00.000'),
);

void main() {
  late FakeFirebaseFirestore firestore;
  late UserFirestoreService sut;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    sut = UserFirestoreService(firestore);
  });

  group('saveUser', () {
    test('sets the document under the user id', () async {
      final user = _userModel();

      await sut.saveUser(user);

      final doc = await firestore.collection('users').doc(user.id).get();
      expect(doc.data(), user.toMap());
    });
  });

  group('getUsers', () {
    test('no filters → returns every user', () async {
      await firestore
          .collection('users')
          .doc('uid-1')
          .set(_rawUser(id: 'uid-1', name: 'Alice'));
      await firestore
          .collection('users')
          .doc('uid-2')
          .set(_rawUser(id: 'uid-2', name: 'Bob'));

      final result = await sut.getUsers();

      expect(result.map((u) => u.id), unorderedEquals(['uid-1', 'uid-2']));
    });

    test('with role → only returns users with the matching role', () async {
      await firestore
          .collection('users')
          .doc('uid-1')
          .set(_rawUser(id: 'uid-1', name: 'Alice', role: UserRole.admin));
      await firestore
          .collection('users')
          .doc('uid-2')
          .set(_rawUser(id: 'uid-2', name: 'Bob'));

      final result = await sut.getUsers(role: UserRole.admin);

      expect(result.map((u) => u.id), ['uid-1']);
    });

    test('with query → only returns users whose name starts with it', () async {
      await firestore
          .collection('users')
          .doc('uid-1')
          .set(_rawUser(id: 'uid-1', name: 'Alice'));
      await firestore
          .collection('users')
          .doc('uid-2')
          .set(_rawUser(id: 'uid-2', name: 'Alan'));
      await firestore
          .collection('users')
          .doc('uid-3')
          .set(_rawUser(id: 'uid-3', name: 'Bob'));

      final result = await sut.getUsers(query: 'Al');

      expect(result.map((u) => u.id), unorderedEquals(['uid-1', 'uid-2']));
    });

    test('with role and query → applies both filters', () async {
      await firestore
          .collection('users')
          .doc('uid-1')
          .set(_rawUser(id: 'uid-1', name: 'Alice', role: UserRole.teacher));
      await firestore
          .collection('users')
          .doc('uid-2')
          .set(_rawUser(id: 'uid-2', name: 'Alan'));

      final result = await sut.getUsers(role: UserRole.teacher, query: 'Al');

      expect(result.map((u) => u.id), ['uid-1']);
    });
  });

  group('getUser', () {
    test('document exists → returns the mapped user', () async {
      await firestore
          .collection('users')
          .doc('uid-1')
          .set(_rawUser(id: 'uid-1', name: 'Alice'));

      final result = await sut.getUser('uid-1');

      expect(result, isNotNull);
      expect(result!.id, 'uid-1');
      expect(result.name, 'Alice');
    });

    test('document missing → returns null', () async {
      final result = await sut.getUser('uid-1');

      expect(result, isNull);
    });
  });

  group('updateUser', () {
    test('updates the document under the user id', () async {
      await firestore
          .collection('users')
          .doc('uid-1')
          .set(_rawUser(id: 'uid-1', name: 'Alice'));
      final updated = _userModel(name: 'Alice Updated');

      await sut.updateUser(updated);

      final doc = await firestore.collection('users').doc('uid-1').get();
      expect(doc.data(), updated.toMap());
    });
  });

  group('deleteUser', () {
    test('deletes the document with the given id', () async {
      await firestore
          .collection('users')
          .doc('uid-1')
          .set(_rawUser(id: 'uid-1', name: 'Alice'));

      await sut.deleteUser('uid-1');

      final doc = await firestore.collection('users').doc('uid-1').get();
      expect(doc.exists, isFalse);
    });
  });
}
