import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:academic_planner/src/core/result/failure.dart';

class ExceptionMapper {
  static Failure map(Object error) {
    if (error is FirebaseAuthException) {
      return _mapFirebaseAuth(error);
    }

    if (error is SocketException) {
      return NetworkFailure('Sem conexão com a internet', error);
    }

    if (error is FormatException) {
      return ValidationFailure('Formato inválido', error);
    }

    return UnknownFailure(error.toString(), error);
  }

  static Failure mapDatabase(Object error) {
    if (error is SocketException) {
      return NetworkFailure('Sem conexão com a internet', error);
    }

    if (error is FormatException) {
      return ValidationFailure('Formato inválido', error);
    }

    return DatabaseFailure(error.toString(), error);
  }

  static Failure _mapFirebaseAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthFailure('Usuário não encontrado');
      case 'wrong-password':
        return const AuthFailure('Senha incorreta');
      case 'email-already-in-use':
        return const AuthFailure('Email já está em uso');
      case 'invalid-email':
        return const AuthFailure('Email inválido');
      case 'weak-password':
        return const AuthFailure('Senha muito fraca');
      case 'invalid-credential':
        return const AuthFailure('Credenciais inválidas');
      case 'network-request-failed':
        return const NetworkFailure('Erro de conexão');
      default:
        return AuthFailure(e.message ?? 'Erro de autenticação', e);
    }
  }
}
