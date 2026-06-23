import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService(this._firebaseAuth, this._googleSignIn);

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Future<UserCredential> signIn(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();

    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> reloadUser() async {
    await _firebaseAuth.currentUser?.reload();
  }

  User? get currentUser => _firebaseAuth.currentUser;

  bool get isEmailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  Future<void> deleteAccount() async {
    await _firebaseAuth.currentUser?.delete();
  }

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}
