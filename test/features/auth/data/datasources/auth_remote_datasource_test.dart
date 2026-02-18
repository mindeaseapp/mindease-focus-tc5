
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindease_focus/features/auth/data/datasources/auth_remote_datasource.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}
class FakeUserAttributes extends Fake implements UserAttributes {}

// Note: AuthResponse and UserResponse are final and might be hard to mock if they don't have a public constructor or are not abstract.
// Supabase AuthResponse has a constructor.

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;
  late AuthRemoteDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(FakeUserAttributes());
  });

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();
    when(() => mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
    dataSource = AuthRemoteDataSource(mockSupabaseClient);
  });

  final tEmail = 'test@example.com';
  final tPassword = 'password123';
  final tName = 'Test User';

  group('signUp', () {
    test('should call signUp on supabase client', () async {
      final mockAuthResponse = AuthResponse(
        session: null, 
        user: MockUser(),
      );
      
      when(() => mockGoTrueClient.signUp(
            email: tEmail,
            password: tPassword,
            data: {'nome': tName},
          )).thenAnswer((_) async => mockAuthResponse);

      await dataSource.signUp(email: tEmail, password: tPassword, nome: tName);

      verify(() => mockGoTrueClient.signUp(
            email: tEmail,
            password: tPassword,
            data: {'nome': tName},
          )).called(1);
    });

    test('should throw exception when user is null', () async {
       final mockAuthResponse = AuthResponse(
        session: null, 
        user: null,
      );

      when(() => mockGoTrueClient.signUp(
            email: tEmail,
            password: tPassword,
            data: {'nome': tName},
          )).thenAnswer((_) async => mockAuthResponse);

      expect(
        () => dataSource.signUp(email: tEmail, password: tPassword, nome: tName),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('signIn', () {
    test('should return user when signIn succeeds', () async {
      final mockUser = MockUser();
      final mockAuthResponse = AuthResponse(
        session: null,
        user: mockUser,
      );

      when(() => mockGoTrueClient.signInWithPassword(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => mockAuthResponse);

      final result = await dataSource.signIn(email: tEmail, password: tPassword);

      expect(result, mockUser);
      verify(() => mockGoTrueClient.signInWithPassword(
            email: tEmail,
            password: tPassword,
          )).called(1);
    });

      test('should throw exception when user is null', () async {
       final mockAuthResponse = AuthResponse(
        session: null, 
        user: null,
      );

      when(() => mockGoTrueClient.signInWithPassword(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => mockAuthResponse);

      expect(
        () => dataSource.signIn(email: tEmail, password: tPassword),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('signOut', () {
    test('should call signOut on supabase client', () async {
      when(() => mockGoTrueClient.signOut()).thenAnswer((_) async => Future.value());

      await dataSource.signOut();

      verify(() => mockGoTrueClient.signOut()).called(1);
    });
  });

  group('getCurrentUser', () {
    test('should return current user', () {
      final mockUser = MockUser();
      when(() => mockGoTrueClient.currentUser).thenReturn(mockUser);

      final result = dataSource.getCurrentUser();

      expect(result, mockUser);
      verify(() => mockGoTrueClient.currentUser).called(1);
    });
  });
  
    group('updatePassword', () {
    final tNewPassword = 'newPassword123';
    test('should call updateUser on supabase client', () async {
      // Mocking UserAttributes is tricky if it overrides ==. 
      // Using any() or matching by properties.
      
      final mockUserResponse = UserResponse.fromJson(<String, dynamic>{
        'id': 'user123',
        'aud': 'authenticated',
        'role': 'authenticated',
        'email': 'test@example.com',
        'app_metadata': <String, dynamic>{},
        'user_metadata': <String, dynamic>{},
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      when(() => mockGoTrueClient.updateUser(any()))
          .thenAnswer((_) async => mockUserResponse);

      await dataSource.updatePassword(tNewPassword);

      verify(() => mockGoTrueClient.updateUser(any())).called(1);
    });
  });
}
