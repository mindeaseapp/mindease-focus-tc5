
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/auth/domain/usecases/login_usecase.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LoginUseCase(mockAuthRepository);
  });

  final tEmail = 'test@example.com';
  final tPassword = 'password123';

  test('should call loginUser on repository with correct parameters', () async {
    when(() => mockAuthRepository.loginUser(email: tEmail, password: tPassword))
        .thenAnswer((_) async => Future.value());

    await useCase(email: tEmail, password: tPassword);

    verify(() => mockAuthRepository.loginUser(email: tEmail, password: tPassword)).called(1);
  });

  test('should throw exception when login fails', () async {
    const tException = 'Login failed';
    when(() => mockAuthRepository.loginUser(email: tEmail, password: tPassword))
        .thenThrow(Exception(tException));

    expect(
      () => useCase(email: tEmail, password: tPassword),
      throwsA(isA<Exception>()),
    );
  });
}
