class AuthUserEntity {
  AuthUserEntity({
    required this.uid,
    required this.emailVerified,
    this.email,
    this.displayName,
  });

  final String uid;
  final bool emailVerified;
  final String? email;
  final String? displayName;
}
