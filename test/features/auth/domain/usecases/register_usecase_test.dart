
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/auth/domain/usecases/register_usecase.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late RegisterUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockAuthRepository);
  });

  final tName = 'Test User';
  final tEmail = 'test@example.com';
  final tPassword = 'password123';

  test('should call registerUser on repository with correct parameters', () async {
    // Arrange
    when(() => mockAuthRepository.registerUser(
          name: tName,
          email: tEmail,
          password: tPassword,
        )).thenAnswer((_) async => Future.value());

    // Act
    await useCase(name: tName, email: tEmail, password: tPassword);

    // Assert
    verify(() => mockAuthRepository.registerUser(
          name: tName,
          email: tEmail,
          password: tPassword,
        )).called(1);
  });

  test('should throw exception when registration fails', () async {
    // Arrange
    final tException = Exception('Registration failed');
    when(() => mockAuthRepository.registerUser(
          name: tName,
          email: tEmail,
          password: tPassword,
        )).thenThrow(tException);

    // Act & Assert
    expect(
      () => useCase(name: tName, email: tEmail, password: tPassword),
      throwsA(isA<Exception>()),
    );
  });
}
