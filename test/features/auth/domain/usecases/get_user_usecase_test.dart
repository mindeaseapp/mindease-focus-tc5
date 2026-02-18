
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindease_focus/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late GetUserUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = GetUserUseCase(mockAuthRepository);
  });

  final tEmail = 'test@example.com';
  final tName = 'Test User';
  final tId = 'user-123';

  test('should return valid UserEntity when repository returns user with metadata', () {
    // Arrange
    final mockUser = MockUser();
    when(() => mockUser.id).thenReturn(tId);
    when(() => mockUser.email).thenReturn(tEmail);
    when(() => mockUser.userMetadata).thenReturn({'nome': tName});
    
    when(() => mockAuthRepository.currentUser).thenReturn(mockUser);

    // Act
    final result = useCase();

    // Assert
    expect(result, isA<UserEntity>());
    expect(result.id, tId);
    expect(result.email, tEmail);
    expect(result.name, tName);
  });

  test('should return UserEntity with default name when metadata is missing', () {
    // Arrange
    final mockUser = MockUser();
    when(() => mockUser.id).thenReturn(tId);
    when(() => mockUser.email).thenReturn(tEmail);
    when(() => mockUser.userMetadata).thenReturn(null);

    when(() => mockAuthRepository.currentUser).thenReturn(mockUser);

    // Act
    final result = useCase();

    // Assert
    expect(result.name, 'Usuário MindEase');
  });

  test('should return empty UserEntity when repository returns null', () {
    // Arrange
    when(() => mockAuthRepository.currentUser).thenReturn(null);

    // Act
    final result = useCase();

    // Assert
    expect(result.id, isEmpty);
    expect(result.name, isEmpty);
    expect(result.email, isEmpty);
  });
}
