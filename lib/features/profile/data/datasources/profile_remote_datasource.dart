import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindease_focus/features/profile/domain/models/user_preferences/user_preferences_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserPreferencesModel> getPreferences(String userId);
  Future<void> updatePreferences(UserPreferencesModel preferences);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserPreferencesModel> getPreferences(String userId) async {
    try {
      final response = await supabaseClient
          .from('preferencias_perfil')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return UserPreferencesModel.defaults(userId);
      }

      return UserPreferencesModel.fromJson(response);
    } on PostgrestException catch (_) {
      return UserPreferencesModel.defaults(userId);
    } catch (_) {
      return UserPreferencesModel.defaults(userId);
    }
  }

  @override
  Future<void> updatePreferences(UserPreferencesModel preferences) async {
    final data = preferences.toJson();

    await supabaseClient.from('preferencias_perfil').upsert(
      data,
      onConflict: 'user_id',
    );
  }
}
