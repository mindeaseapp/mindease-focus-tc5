import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/user_preferences/user_preferences_model.dart';

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
          .single();

      return UserPreferencesModel.fromJson(response);
    } catch (e) {
      // Se der erro (ex: não existe ainda), retornamos o default.
      return UserPreferencesModel.defaults(userId);
    }
  }

  @override
  Future<void> updatePreferences(UserPreferencesModel preferences) async {
    await supabaseClient
        .from('preferencias_perfil')
        .upsert(preferences.toJson());
  }
}
