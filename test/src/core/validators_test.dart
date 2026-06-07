import 'package:academic_planner/src/core/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.required', () {
    test('null returns error', () {
      expect(Validators.required(null), isNotNull);
    });

    test('empty string returns error', () {
      expect(Validators.required(''), isNotNull);
    });

    test('only spaces returns error', () {
      expect(Validators.required('   '), isNotNull);
    });

    test('only tabs/newlines returns error', () {
      expect(Validators.required('\t\n'), isNotNull);
    });

    test('valid string returns null', () {
      expect(Validators.required('hello'), isNull);
    });

    test('string with surrounding spaces returns null', () {
      expect(Validators.required('  hello  '), isNull);
    });

    test('custom message returned on failure', () {
      expect(
        Validators.required(null, message: 'Campo vazio'),
        equals('Campo vazio'),
      );
    });

    test('default message returned on failure', () {
      expect(
        Validators.required(null),
        equals('Este campo é obrigatório'),
      );
    });
  });

  group('Validators.email', () {
    test('null returns null (optional field)', () {
      expect(Validators.email(null), isNull);
    });

    test('empty string returns null (optional field)', () {
      expect(Validators.email(''), isNull);
    });

    test('only spaces returns null (optional field)', () {
      expect(Validators.email('   '), isNull);
    });

    test('valid email returns null', () {
      expect(Validators.email('user@example.com'), isNull);
    });

    test('valid email with subdomain returns null', () {
      expect(Validators.email('user@mail.example.com'), isNull);
    });

    test('valid email with plus returns null', () {
      expect(Validators.email('user.name+tag@example.org'), isNull);
    });

    test('missing @ returns error', () {
      expect(Validators.email('userexample.com'), isNotNull);
    });

    test('missing domain returns error', () {
      expect(Validators.email('user@'), isNotNull);
    });

    test('missing TLD returns error', () {
      expect(Validators.email('user@example'), isNotNull);
    });

    test('double @ returns error', () {
      expect(Validators.email('user@@example.com'), isNotNull);
    });

    test('spaces inside email returns error', () {
      expect(Validators.email('us er@example.com'), isNotNull);
    });

    test('custom message returned on failure', () {
      expect(
        Validators.email('invalid', message: 'E-mail inválido'),
        equals('E-mail inválido'),
      );
    });

    test('default message returned on failure', () {
      expect(
        Validators.email('invalid'),
        equals('Insira um e-mail válido'),
      );
    });
  });

  group('Validators.url', () {
    test('null returns null (optional field)', () {
      expect(Validators.url(null), isNull);
    });

    test('empty string returns null (optional field)', () {
      expect(Validators.url(''), isNull);
    });

    test('only spaces returns null (optional field)', () {
      expect(Validators.url('   '), isNull);
    });

    test('https URL returns null', () {
      expect(Validators.url('https://example.com'), isNull);
    });

    test('http URL returns null', () {
      expect(Validators.url('http://example.com'), isNull);
    });

    test('URL without protocol returns null', () {
      expect(Validators.url('example.com'), isNull);
    });

    test('URL with path returns null', () {
      expect(Validators.url('https://example.com/path/to/page'), isNull);
    });

    test('URL with subdomain returns null', () {
      expect(Validators.url('https://sub.example.com'), isNull);
    });

    test('URL with trailing slash returns null', () {
      expect(Validators.url('https://example.com/'), isNull);
    });

    test('plain word without dot returns error', () {
      expect(Validators.url('notaurl'), isNotNull);
    });

    test('ftp protocol returns error', () {
      expect(Validators.url('ftp://example.com'), isNotNull);
    });

    test('URL with spaces returns error', () {
      expect(Validators.url('https://exam ple.com'), isNotNull);
    });

    test('custom message returned on failure', () {
      expect(
        Validators.url('notaurl', message: 'Link inválido'),
        equals('Link inválido'),
      );
    });

    test('default message returned on failure', () {
      expect(
        Validators.url('notaurl'),
        equals('Insira um link válido'),
      );
    });
  });

  group('Validators.compare', () {
    test('equal strings returns null', () {
      expect(Validators.compare('abc', 'abc'), isNull);
    });

    test('both null returns null', () {
      expect(Validators.compare(null, null), isNull);
    });

    test('different strings returns error', () {
      expect(Validators.compare('abc', 'xyz'), isNotNull);
    });

    test('value null and target non-null returns error', () {
      expect(Validators.compare(null, 'abc'), isNotNull);
    });

    test('value non-null and target null returns error', () {
      expect(Validators.compare('abc', null), isNotNull);
    });

    test('case-sensitive comparison: different case returns error', () {
      expect(Validators.compare('ABC', 'abc'), isNotNull);
    });

    test('empty strings equal returns null', () {
      expect(Validators.compare('', ''), isNull);
    });

    test('custom message returned on failure', () {
      expect(
        Validators.compare('a', 'b', message: 'Não coincidem'),
        equals('Não coincidem'),
      );
    });

    test('default message returned on failure', () {
      expect(
        Validators.compare('a', 'b'),
        equals('Os campos não coincidem'),
      );
    });
  });

  group('Validators.multiple', () {
    test('all pass returns null', () {
      final validator = Validators.multiple([
        Validators.required,
        Validators.email,
      ]);
      expect(validator('user@example.com'), isNull);
    });

    test('stops at first error — required fails, email not reached', () {
      final validator = Validators.multiple([
        Validators.required,
        Validators.email,
      ]);
      expect(validator(null), equals('Este campo é obrigatório'));
    });

    test('first passes, second fails', () {
      final validator = Validators.multiple([
        Validators.required,
        Validators.email,
      ]);
      expect(validator('notanemail'), equals('Insira um e-mail válido'));
    });

    test('empty list returns null', () {
      final validator = Validators.multiple([]);
      expect(validator('anything'), isNull);
    });

    test('single validator failure returned', () {
      final validator = Validators.multiple([Validators.required]);
      expect(validator(''), isNotNull);
    });

    test('single validator pass returns null', () {
      final validator = Validators.multiple([Validators.required]);
      expect(validator('value'), isNull);
    });

    test('three validators — first fails, others not called', () {
      var secondCalled = false;
      var thirdCalled = false;

      final validator = Validators.multiple([
        (_) => 'first error',
        (v) {
          secondCalled = true;
          return null;
        },
        (v) {
          thirdCalled = true;
          return null;
        },
      ]);

      final result = validator('any');
      expect(result, equals('first error'));
      expect(secondCalled, isFalse);
      expect(thirdCalled, isFalse);
    });

    test('custom messages propagate through multiple', () {
      final validator = Validators.multiple([
        (v) => Validators.required(v, message: 'Preencha este campo'),
      ]);
      expect(validator(null), equals('Preencha este campo'));
    });
  });
}
