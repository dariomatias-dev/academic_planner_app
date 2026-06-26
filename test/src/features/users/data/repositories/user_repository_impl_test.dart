import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/users/data/models/user_model.dart';
import 'package:academic_planner/src/features/users/data/repositories/user_repository_impl.dart';
import 'package:academic_planner/src/features/users/data/services/user_firestore_service.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserFirestoreService extends Mock implements UserFirestoreService {}

UserModel _baseModel({String id = 'user-1'}) => UserModel(
  id: id,
  email: 'a@b.com',
  name: 'Alice',
  role: UserRole.student,
  createdAt: DateTime.parse('2024-01-01T00:00:00.000'),
  updatedAt: DateTime.parse('2024-01-01T00:00:00.000'),
);

UserEntity _baseEntity({String id = 'user-1'}) => UserEntity(
  id: id,
  email: 'a@b.com',
  name: 'Alice',
  createdAt: DateTime.parse('2024-01-01T00:00:00.000'),
  updatedAt: DateTime.parse('2024-01-01T00:00:00.000'),
);

void main() {
  late MockUserFirestoreService mockService;
  late UserRepositoryImpl sut;

  setUpAll(() {
    registerFallbackValue(_baseModel());
  });

  setUp(() {
    mockService = MockUserFirestoreService();
    sut = UserRepositoryImpl(mockService);
  });

  group('create', () {
    test('success → returns Success', () async {
      when(() => mockService.saveUser(any())).thenAnswer((_) async {});

      final result = await sut.create(_baseEntity());

      expect(result, isA<Success<void>>());
      verify(() => mockService.saveUser(any())).called(1);
    });

    test('exception → returns Failure', () async {
      when(() => mockService.saveUser(any())).thenThrow(Exception('db error'));

      final result = await sut.create(_baseEntity());

      expect(result, isA<Failure<void>>());
    });
  });

  group('getAll', () {
    test('success → returns Success with mapped users', () async {
      when(
        () => mockService.getUsers(
          query: any(named: 'query'),
          role: any(named: 'role'),
        ),
      ).thenAnswer((_) async => [_baseModel(id: '1'), _baseModel(id: '2')]);

      final result = await sut.getAll();

      expect(result, isA<Success<List<UserEntity>>>());
      expect((result as Success<List<UserEntity>>).value.length, 2);
    });

    test('empty result → Success with empty list', () async {
      when(
        () => mockService.getUsers(
          query: any(named: 'query'),
          role: any(named: 'role'),
        ),
      ).thenAnswer((_) async => []);

      final result = await sut.getAll();

      expect(result, isA<Success<List<UserEntity>>>());
      expect((result as Success<List<UserEntity>>).value, isEmpty);
    });

    test('exception → returns Failure', () async {
      when(
        () => mockService.getUsers(
          query: any(named: 'query'),
          role: any(named: 'role'),
        ),
      ).thenThrow(Exception('db error'));

      final result = await sut.getAll();

      expect(result, isA<Failure<List<UserEntity>>>());
    });
  });

  group('getById', () {
    test('user found → Success with user', () async {
      when(
        () => mockService.getUser(any()),
      ).thenAnswer((_) async => _baseModel());

      final result = await sut.getById('user-1');

      expect(result, isA<Success<UserEntity?>>());
      expect((result as Success<UserEntity?>).value?.id, 'user-1');
    });

    test('user not found → Success(null)', () async {
      when(() => mockService.getUser(any())).thenAnswer((_) async => null);

      final result = await sut.getById('no-such-id');

      expect(result, isA<Success<UserEntity?>>());
      expect((result as Success<UserEntity?>).value, isNull);
    });

    test('exception → returns Failure', () async {
      when(() => mockService.getUser(any())).thenThrow(Exception('db error'));

      final result = await sut.getById('user-1');

      expect(result, isA<Failure<UserEntity?>>());
    });
  });

  group('update', () {
    test('success → returns Success', () async {
      when(() => mockService.updateUser(any())).thenAnswer((_) async {});

      final result = await sut.update(_baseEntity());

      expect(result, isA<Success<void>>());
      verify(() => mockService.updateUser(any())).called(1);
    });

    test('exception → returns Failure', () async {
      when(
        () => mockService.updateUser(any()),
      ).thenThrow(Exception('db error'));

      final result = await sut.update(_baseEntity());

      expect(result, isA<Failure<void>>());
    });
  });

  group('delete', () {
    test('success → returns Success', () async {
      when(() => mockService.deleteUser(any())).thenAnswer((_) async {});

      final result = await sut.delete('user-1');

      expect(result, isA<Success<void>>());
      verify(() => mockService.deleteUser('user-1')).called(1);
    });

    test('exception → returns Failure', () async {
      when(
        () => mockService.deleteUser(any()),
      ).thenThrow(Exception('db error'));

      final result = await sut.delete('user-1');

      expect(result, isA<Failure<void>>());
    });
  });
}
