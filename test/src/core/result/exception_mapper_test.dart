import 'dart:io';

import 'package:academic_planner/src/core/result/exception_mapper.dart';
import 'package:academic_planner/src/core/result/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

FirebaseAuthException _authEx(String code, {String? message}) =>
    FirebaseAuthException(code: code, message: message);

void main() {
  group('ExceptionMapper.mapAuth — FirebaseAuthException codes', () {
    test('user-not-found → AuthFailure', () {
      final result = ExceptionMapper.mapAuth(_authEx('user-not-found'));

      expect(result, isA<AuthFailure>());
      expect(result.message, 'Usuário não encontrado');
    });

    test('wrong-password → AuthFailure', () {
      final result = ExceptionMapper.mapAuth(_authEx('wrong-password'));

      expect(result, isA<AuthFailure>());
      expect(result.message, 'Senha incorreta');
    });

    test('email-already-in-use → AuthFailure', () {
      final result = ExceptionMapper.mapAuth(_authEx('email-already-in-use'));

      expect(result, isA<AuthFailure>());
      expect(result.message, 'Email já está em uso');
    });

    test('invalid-email → AuthFailure', () {
      final result = ExceptionMapper.mapAuth(_authEx('invalid-email'));

      expect(result, isA<AuthFailure>());
      expect(result.message, 'Email inválido');
    });

    test('weak-password → AuthFailure', () {
      final result = ExceptionMapper.mapAuth(_authEx('weak-password'));

      expect(result, isA<AuthFailure>());
      expect(result.message, 'Senha muito fraca');
    });

    test('invalid-credential → AuthFailure', () {
      final result = ExceptionMapper.mapAuth(_authEx('invalid-credential'));

      expect(result, isA<AuthFailure>());
      expect(result.message, 'Credenciais inválidas');
    });

    test('network-request-failed → NetworkFailure', () {
      final result = ExceptionMapper.mapAuth(_authEx('network-request-failed'));

      expect(result, isA<NetworkFailure>());
      expect(result.message, 'Erro de conexão');
    });

    test('unknown code with message → AuthFailure with exception message', () {
      final result = ExceptionMapper.mapAuth(
        _authEx('some-unknown', message: 'Detalhe'),
      );

      expect(result, isA<AuthFailure>());
      expect(result.message, 'Detalhe');
    });

    test('unknown code without message → AuthFailure with default message', () {
      final result = ExceptionMapper.mapAuth(_authEx('some-unknown'));

      expect(result, isA<AuthFailure>());
      expect(result.message, 'Erro de autenticação');
    });
  });

  group('ExceptionMapper.mapAuth — outros tipos', () {
    test('SocketException → NetworkFailure', () {
      final result = ExceptionMapper.mapAuth(
        const SocketException('no network'),
      );

      expect(result, isA<NetworkFailure>());
      expect(result.message, 'Sem conexão com a internet');
    });

    test('FormatException → ValidationFailure', () {
      final result = ExceptionMapper.mapAuth(const FormatException());

      expect(result, isA<ValidationFailure>());
      expect(result.message, 'Formato inválido');
    });

    test('erro desconhecido → UnknownFailure', () {
      final result = ExceptionMapper.mapAuth(Exception('qualquer coisa'));

      expect(result, isA<UnknownFailure>());
      expect(result.message, 'Erro inesperado');
    });
  });

  group('ExceptionMapper.mapDatabase', () {
    test('FirebaseException → DatabaseFailure', () {
      final result = ExceptionMapper.mapDatabase(
        FirebaseException(plugin: 'firestore', code: 'unavailable'),
      );

      expect(result, isA<DatabaseFailure>());
      expect(result.message, 'Erro no banco de dados');
    });

    test(
      'FirebaseAuthException (subtype FirebaseException) → DatabaseFailure',
      () {
        final result = ExceptionMapper.mapDatabase(
          _authEx('permission-denied'),
        );

        expect(result, isA<DatabaseFailure>());
      },
    );

    test('SocketException → NetworkFailure', () {
      final result = ExceptionMapper.mapDatabase(
        const SocketException('no network'),
      );

      expect(result, isA<NetworkFailure>());
      expect(result.message, 'Sem conexão com a internet');
    });

    test('FormatException → ValidationFailure', () {
      final result = ExceptionMapper.mapDatabase(const FormatException());

      expect(result, isA<ValidationFailure>());
      expect(result.message, 'Formato inválido');
    });

    test('erro desconhecido → UnknownFailure', () {
      final result = ExceptionMapper.mapDatabase(Exception('qualquer coisa'));

      expect(result, isA<UnknownFailure>());
      expect(result.message, 'Erro inesperado');
    });
  });
}
