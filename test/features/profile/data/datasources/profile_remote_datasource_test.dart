
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindease_focus/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:mindease_focus/features/profile/domain/models/user_preferences/user_preferences_model.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';

// Mocks for Supabase query chain

// Fakes to handle "Builder is a Future"
class FakePostgrestBuilder<T> extends Fake implements PostgrestFilterBuilder<T> {
  final T _result;
  FakePostgrestBuilder(this._result);

  @override
  Future<S> then<S>(FutureOr<S> Function(T value) onValue, {Function? onError}) async {
    return onValue(_result);
  }
}

class FakePostgrestTransformBuilder<T> extends Fake implements PostgrestTransformBuilder<T> {
  final T _result;
  FakePostgrestTransformBuilder(this._result);

  @override
  Future<S> then<S>(FutureOr<S> Function(T value) onValue, {Function? onError}) async {
    return onValue(_result);
  }
}

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}
class MockPostgrestTransformBuilder extends Mock implements PostgrestTransformBuilder<List<Map<String, dynamic>>> {}


void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late MockPostgrestFilterBuilder mockFilterBuilder;
  late MockPostgrestFilterBuilder mockTransformBuilder;
  late ProfileRemoteDataSourceImpl dataSource;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    mockFilterBuilder = MockPostgrestFilterBuilder();
    mockTransformBuilder = MockPostgrestFilterBuilder(); // Note: mockTransformBuilder is typed as MockPostgrestTransformBuilder but assigned MockPostgrestFilterBuilder? 
    // Wait, in original code: late MockPostgrestFilterBuilder mockTransformBuilder;
    // But in the class defs above: class MockPostgrestTransformBuilder ...
    // Let's stick to the types.
    // Actually, in the ORIGINAL file, mockTransformBuilder was defined as `late MockPostgrestFilterBuilder mockTransformBuilder;` 
    // BUT mapped to `MockPostgrestTransformBuilder` class? 
    // Let's look at the file content I saw in Step 71.
    // Line 33: late MockPostgrestFilterBuilder mockTransformBuilder;
    // Line 40: mockTransformBuilder = MockPostgrestFilterBuilder();
    // BUT usage: when(() => mockFilterBuilder.eq(...)).thenReturn(mockTransformBuilder);
    // And mockTransformBuilder.maybeSingle().
    // PostgrestFilterBuilder has maybeSingle? Yes, via inheritance? or mixin?
    // If I use FakePostgrestTransformBuilder for maybeSingle, it should be fine.
    
    // I will use proper assignments here.
    
    mockTransformBuilder = MockPostgrestFilterBuilder(); 
    dataSource = ProfileRemoteDataSourceImpl(mockSupabaseClient);
  });

  const tUserId = 'user123';
  final tPreferencesMap = {
    'user_id': tUserId,
    'hide_distractions': false,
    'high_contrast': false,
    'dark_mode': false,
    'break_reminder': true,
    'task_time_alert': true,
    'smooth_transition': true,
    'push_notifications': true,
    'notification_sounds': false,
    'complexity': 'medium',
  };
  
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
    test('should return UserPreferencesModel when data exists', () async {
      when(() => mockSupabaseClient.from(any())).thenAnswer((_) => mockQueryBuilder);
      when(() => mockQueryBuilder.select()).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.eq(any(), any())).thenAnswer((_) => mockTransformBuilder);
      when(() => mockTransformBuilder.maybeSingle()).thenAnswer((_) => FakePostgrestTransformBuilder(tPreferencesMap));

      final result = await dataSource.getPreferences(tUserId);

      expect(result.userId, tUserId);
      expect(result.complexity, InterfaceComplexity.medium);
    });

    test('should return default preferences when data is null', () async {
      when(() => mockSupabaseClient.from(any())).thenAnswer((_) => mockQueryBuilder);
      when(() => mockQueryBuilder.select()).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.eq(any(), any())).thenAnswer((_) => mockTransformBuilder);
      when(() => mockTransformBuilder.maybeSingle()).thenAnswer((_) => FakePostgrestTransformBuilder(null));

      final result = await dataSource.getPreferences(tUserId);

      expect(result.userId, tUserId);
      // Defaults check
      expect(result.breakReminder, true);
    });

    test('should return default preferences when generic Exception occurs', () async {
       when(() => mockSupabaseClient.from(any())).thenThrow(Exception());

      final result = await dataSource.getPreferences(tUserId);

      expect(result.userId, tUserId);
    });
  });

  group('updatePreferences', () {
    test('should call upsert on supabase', () async {
      when(() => mockSupabaseClient.from(any())).thenAnswer((_) => mockQueryBuilder);
      when(() => mockQueryBuilder.upsert(any(), onConflict: any(named: 'onConflict'))).thenAnswer((_) => FakePostgrestBuilder([]));

      await dataSource.updatePreferences(tPreferences);

      verify(() => mockSupabaseClient.from('preferencias_perfil')).called(1);
      verify(() => mockQueryBuilder.upsert(tPreferences.toJson(), onConflict: 'user_id')).called(1);
    });
  });
}
