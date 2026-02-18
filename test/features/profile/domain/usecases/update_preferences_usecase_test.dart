
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/profile/domain/usecases/update_preferences_usecase.dart';
import 'package:mindease_focus/features/profile/data/repositories/profile_repository.dart';
import 'package:mindease_focus/features/profile/domain/models/user_preferences/user_preferences_model.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;
  late UpdatePreferencesUseCase useCase;

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = UpdatePreferencesUseCase(mockRepository);
  });

  final tPreferences = UserPreferencesModel(
    userId: 'user123',
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

  test('should call updatePreferences on repository', () async {
    when(() => mockRepository.updatePreferences(tPreferences))
        .thenAnswer((_) async => Future.value());

    await useCase(tPreferences);

    verify(() => mockRepository.updatePreferences(tPreferences)).called(1);
  });
}
