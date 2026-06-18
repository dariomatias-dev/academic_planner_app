import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:academic_planner/src/features/users/presentation/view_models/user_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

UserEntity _user({String id = 'uid-1', UserRole role = UserRole.student}) =>
    UserEntity(
      id: id,
      email: 'a@b.com',
      name: 'Alice',
      role: role,
      createdAt: DateTime.parse('2024-01-01T00:00:00.000'),
      updatedAt: DateTime.parse('2024-01-01T00:00:00.000'),
    );

void main() {
  late MockUserRepository mockRepository;
  late UserViewModel sut;

  setUpAll(() {
    registerFallbackValue(_user());
  });

  setUp(() {
    mockRepository = MockUserRepository();
    sut = UserViewModel(mockRepository);
  });

  group('loadUser', () {
    test('success sets user and clears error', () async {
      final user = _user();
      when(
        () => mockRepository.getById('uid-1'),
      ).thenAnswer((_) async => Success<UserEntity?>(user));

      await sut.loadUser('uid-1');

      expect(sut.user, user);
      expect(sut.error, isNull);
    });

    test('user not found sets user to null without error', () async {
      when(
        () => mockRepository.getById('missing'),
      ).thenAnswer((_) async => const Success<UserEntity?>(null));

      await sut.loadUser('missing');

      expect(sut.user, isNull);
      expect(sut.error, isNull);
    });

    test('failure sets error message', () async {
      when(() => mockRepository.getById('uid-1')).thenAnswer(
        (_) async => const Failure<UserEntity?>(DatabaseFailure('not found')),
      );

      await sut.loadUser('uid-1');

      expect(sut.error, 'not found');
    });
  });

  group('listUsers', () {
    test('returns users from repository', () async {
      final users = [_user()];
      when(
        () => mockRepository.getAll(),
      ).thenAnswer((_) async => Success<List<UserEntity>>(users));

      final result = await sut.listUsers();

      expect(result, users);
      expect(sut.error, isNull);
    });

    test('forwards query and role filters', () async {
      when(
        () => mockRepository.getAll(query: 'ali', role: UserRole.admin),
      ).thenAnswer((_) async => const Success<List<UserEntity>>([]));

      await sut.listUsers(query: 'ali', role: UserRole.admin);

      verify(
        () => mockRepository.getAll(query: 'ali', role: UserRole.admin),
      ).called(1);
    });

    test('failure sets error and returns empty list', () async {
      when(() => mockRepository.getAll()).thenAnswer(
        (_) async =>
            const Failure<List<UserEntity>>(DatabaseFailure('list failed')),
      );

      final result = await sut.listUsers();

      expect(result, isEmpty);
      expect(sut.error, 'list failed');
    });
  });

  group('updateUser', () {
    test('success updates the current user and clears error', () async {
      final user = _user();
      when(
        () => mockRepository.update(user),
      ).thenAnswer((_) async => const Success<void>(null));

      await sut.updateUser(user);

      expect(sut.user, user);
      expect(sut.error, isNull);
    });

    test('failure sets error and leaves user untouched', () async {
      final user = _user();
      when(() => mockRepository.update(user)).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('update failed')),
      );

      await sut.updateUser(user);

      expect(sut.user, isNull);
      expect(sut.error, 'update failed');
    });
  });

  group('deleteUser', () {
    test('success clears the current user', () async {
      final user = _user();
      when(
        () => mockRepository.getById('uid-1'),
      ).thenAnswer((_) async => Success<UserEntity?>(user));
      await sut.loadUser('uid-1');
      when(
        () => mockRepository.delete('uid-1'),
      ).thenAnswer((_) async => const Success<void>(null));

      await sut.deleteUser('uid-1');

      expect(sut.user, isNull);
      expect(sut.error, isNull);
    });

    test('failure sets error message', () async {
      when(() => mockRepository.delete('uid-1')).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('delete failed')),
      );

      await sut.deleteUser('uid-1');

      expect(sut.error, 'delete failed');
    });
  });
}
