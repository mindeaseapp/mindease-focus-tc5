import 'package:mindease_focus/features/profile/data/repositories/profile_repository.dart';
import 'package:mindease_focus/features/profile/domain/models/user_preferences/user_preferences_model.dart';

class UpdatePreferencesUseCase {
  final ProfileRepository _repository;

  UpdatePreferencesUseCase(this._repository);

  Future<void> call(UserPreferencesModel preferences) async {
    await _repository.updatePreferences(preferences);
  }
}
