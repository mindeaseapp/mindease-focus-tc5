
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/profile/domain/usecases/get_preferences_usecase.dart';
import 'package:mindease_focus/features/profile/data/repositories/profile_repository.dart';
import 'package:mindease_focus/features/profile/domain/models/user_preferences/user_preferences_model.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;
  late GetPreferencesUseCase useCase;

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = GetPreferencesUseCase(mockRepository);
  });

  const tUserId = 'user123';
  final tPreferences = UserPreferencesModel(
    userId: tUserId,
    hideDistractions: false,
    highContrast: false,
    darkMode: false,
    breakReminder: true,
    taskTimeAlert: true,
    smoothTransition: true,
    pushNotifications: true,
    notificationSounds: false,
    complexity: InterfaceComplexity.medium,
  );

  test('should get preferences from repository', () async {
    when(() => mockRepository.getPreferences(tUserId))
        .thenAnswer((_) async => tPreferences);

    final result = await useCase(tUserId);

    expect(result, tPreferences);
    verify(() => mockRepository.getPreferences(tUserId)).called(1);
  });
}
