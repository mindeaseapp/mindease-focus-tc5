
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/profile/domain/usecases/get_preferences_usecase.dart';
import 'package:mindease_focus/features/profile/domain/usecases/update_preferences_usecase.dart';
import 'package:mindease_focus/features/profile/domain/models/user_preferences/user_preferences_model.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';

class MockGetPreferencesUseCase extends Mock implements GetPreferencesUseCase {}
class MockUpdatePreferencesUseCase extends Mock implements UpdatePreferencesUseCase {}
class MockUserPreferencesModel extends Mock implements UserPreferencesModel {} // If needed for complex mocking

void main() {
  late ProfilePreferencesController controller;
  late MockGetPreferencesUseCase mockGetPreferencesUseCase;
  late MockUpdatePreferencesUseCase mockUpdatePreferencesUseCase;

  setUp(() {
    mockGetPreferencesUseCase = MockGetPreferencesUseCase();
    mockUpdatePreferencesUseCase = MockUpdatePreferencesUseCase();
    controller = ProfilePreferencesController(
      getPreferencesUseCase: mockGetPreferencesUseCase,
      updatePreferencesUseCase: mockUpdatePreferencesUseCase,
    );
     registerFallbackValue(UserPreferencesModel(
        userId: '1',
        hideDistractions: false,
        highContrast: false,
        darkMode: false,
        breakReminder: true,
        taskTimeAlert: true,
        smoothTransition: true,
        pushNotifications: true,
        notificationSounds: false,
        complexity: InterfaceComplexity.medium));
  });

  group('ProfilePreferencesController', () {
    test('initial state should be default', () {
      expect(controller.hideDistractions, false);
      expect(controller.highContrast, false);
      expect(controller.darkMode, false);
      expect(controller.breakReminder, true);
    });

    test('loadPreferences should update state on success', () async {
       final prefs = UserPreferencesModel(
        userId: 'user1',
        hideDistractions: true,
        highContrast: true,
        darkMode: true,
        breakReminder: false,
        taskTimeAlert: false,
        smoothTransition: false,
        pushNotifications: false,
        notificationSounds: false,
        complexity: InterfaceComplexity.advanced,
      );

      when(() => mockGetPreferencesUseCase('user1')).thenAnswer((_) async => prefs);

      await controller.loadPreferences('user1');

      expect(controller.hideDistractions, true);
      expect(controller.highContrast, true);
      expect(controller.darkMode, true);
      expect(controller.breakReminder, false);
      // ... verify other fields
    });

     test('loadPreferences should not update state on error', () async {
      when(() => mockGetPreferencesUseCase('user1')).thenThrow(Exception('Load failed'));

      // Capture initial state
      final initialHideDistractions = controller.hideDistractions;

      await controller.loadPreferences('user1');

      expect(controller.hideDistractions, initialHideDistractions);
    });

    // Note: Testing debounced save would require fake clock or waiting, sticking to state change verification logic
    test('setters should update state', () {
       controller.setHideDistractions(true);
       expect(controller.hideDistractions, true);

       controller.setHighContrast(true);
       expect(controller.highContrast, true);

       controller.setDarkMode(true);
       expect(controller.darkMode, true);
    });
  });
}
