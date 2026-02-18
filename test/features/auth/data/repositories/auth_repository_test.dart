
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';
import 'package:mindease_focus/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthRemoteDataSource mockDataSource;
  late AuthRepository repository;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepository(mockDataSource);
  });

  final tEmail = 'test@example.com';
  final tPassword = 'password123';
  final tName = 'Test User';

  group('registerUser', () {
    test('should call signUp on datasource', () async {
      when(() => mockDataSource.signUp(email: tEmail, password: tPassword, nome: tName))
          .thenAnswer((_) async => Future.value());

      await repository.registerUser(name: tName, email: tEmail, password: tPassword);

      verify(() => mockDataSource.signUp(email: tEmail, password: tPassword, nome: tName)).called(1);
    });

    test('should throw Exception when datasource fails', () async {
      when(() => mockDataSource.signUp(email: tEmail, password: tPassword, nome: tName))
          .thenThrow(Exception('Error'));

      expect(
        () => repository.registerUser(name: tName, email: tEmail, password: tPassword),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('loginUser', () {
    test('should call signIn on datasource', () async {
      when(() => mockDataSource.signIn(email: tEmail, password: tPassword))
          .thenAnswer((_) async => MockUser());

      await repository.loginUser(email: tEmail, password: tPassword);

      verify(() => mockDataSource.signIn(email: tEmail, password: tPassword)).called(1);
    });

    test('should throw Exception when datasource fails', () async {
      when(() => mockDataSource.signIn(email: tEmail, password: tPassword))
          .thenThrow(Exception('Error'));

      expect(
        () => repository.loginUser(email: tEmail, password: tPassword),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('logoutUser', () {
    test('should call signOut on datasource', () async {
      when(() => mockDataSource.signOut()).thenAnswer((_) async => Future.value());

      await repository.logoutUser();

      verify(() => mockDataSource.signOut()).called(1);
    });
  });

  group('updateUserPassword', () {
    final tNewPassword = 'newPassword123';
    test('should call updatePassword on datasource', () async {
      when(() => mockDataSource.updatePassword(tNewPassword))
          .thenAnswer((_) async => Future.value());

      await repository.updateUserPassword(tNewPassword);

      verify(() => mockDataSource.updatePassword(tNewPassword)).called(1);
    });

    test('should throw Exception when datasource fails', () async {
      when(() => mockDataSource.updatePassword(tNewPassword))
          .thenThrow(Exception('Error'));

      expect(
        () => repository.updateUserPassword(tNewPassword),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('currentUser', () {
    test('should return user from datasource', () {
      final mockUser = MockUser();
      when(() => mockDataSource.getCurrentUser()).thenReturn(mockUser);

      final result = repository.currentUser;

      expect(result, mockUser);
      verify(() => mockDataSource.getCurrentUser()).called(1);
    });
  });
}
