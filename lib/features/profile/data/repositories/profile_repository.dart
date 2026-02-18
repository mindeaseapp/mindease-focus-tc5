import 'package:mindease_focus/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:mindease_focus/features/profile/domain/models/user_preferences/user_preferences_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource dataSource;

  ProfileRepository(this.dataSource);

  Future<UserPreferencesModel> getPreferences(String userId) async {
    return await dataSource.getPreferences(userId);
  }

  Future<void> updatePreferences(UserPreferencesModel preferences) async {
    return await dataSource.updatePreferences(preferences);
  }
}
