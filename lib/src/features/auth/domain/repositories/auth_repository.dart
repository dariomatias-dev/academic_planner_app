import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  User? get currentUser;

  Future<UserCredential> signIn(String email, String password);

  Future<UserCredential> signUp(String email, String password);

  Future<void> signOut();

  Stream<User?> authStateChanges();

  Future<void> sendEmailVerification();

  Future<void> reloadUser();
}
