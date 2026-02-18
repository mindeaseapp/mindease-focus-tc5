
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/profile/data/repositories/profile_repository.dart';
import 'package:mindease_focus/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:mindease_focus/features/profile/domain/models/user_preferences/user_preferences_model.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';

class MockProfileRemoteDataSource extends Mock implements ProfileRemoteDataSource {}

void main() {
  late MockProfileRemoteDataSource mockDataSource;
  late ProfileRepository repository;

  setUp(() {
    mockDataSource = MockProfileRemoteDataSource();
    repository = ProfileRepository(mockDataSource);
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

  group('getPreferences', () {
    test('should return preferences from datasource', () async {
      when(() => mockDataSource.getPreferences(tUserId))
          .thenAnswer((_) async => tPreferences);

      final result = await repository.getPreferences(tUserId);

      expect(result, tPreferences);
      verify(() => mockDataSource.getPreferences(tUserId)).called(1);
    });
  });

  group('updatePreferences', () {
    test('should call updatePreferences on datasource', () async {
      when(() => mockDataSource.updatePreferences(tPreferences))
          .thenAnswer((_) async => Future.value());

      await repository.updatePreferences(tPreferences);

      verify(() => mockDataSource.updatePreferences(tPreferences)).called(1);
    });
  });
}
