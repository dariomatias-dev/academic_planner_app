import 'dart:io';

import 'package:academic_planner/src/core/result/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExceptionMapper {
  const ExceptionMapper._();

  static AppFailure mapAuth(Object error) {
    if (error is FirebaseAuthException) {
      return _mapFirebaseAuth(error);
    }

    if (error is SocketException) {
      return const NetworkFailure('Sem conexão com a internet');
    }

    if (error is FormatException) {
      return const ValidationFailure('Formato inválido');
    }

    return const UnknownFailure('Erro inesperado');
  }

  static AppFailure mapDatabase(Object error) {
    if (error is FirebaseException) {
      return const DatabaseFailure('Erro no banco de dados');
    }

    if (error is SocketException) {
      return const NetworkFailure('Sem conexão com a internet');
    }

    if (error is FormatException) {
      return const ValidationFailure('Formato inválido');
    }

    return const UnknownFailure('Erro inesperado');
  }

  static AppFailure _mapFirebaseAuth(FirebaseAuthException e) {
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
        return AuthFailure(e.message ?? 'Erro de autenticação');
    }
  }
}
