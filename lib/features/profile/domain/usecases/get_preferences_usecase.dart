import 'package:mindease_focus/features/profile/data/repositories/profile_repository.dart';
import 'package:mindease_focus/features/profile/domain/models/user_preferences/user_preferences_model.dart';

class GetPreferencesUseCase {
  final ProfileRepository _repository;

  GetPreferencesUseCase(this._repository);

  Future<UserPreferencesModel> call(String userId) async {
    return await _repository.getPreferences(userId);
  }
}
