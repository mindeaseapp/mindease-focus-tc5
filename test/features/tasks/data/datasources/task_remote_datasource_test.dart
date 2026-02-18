
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindease_focus/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';


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
  late MockPostgrestTransformBuilder mockTransformBuilder;
  late TaskRemoteDataSourceImpl dataSource;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    mockFilterBuilder = MockPostgrestFilterBuilder();
    mockTransformBuilder = MockPostgrestTransformBuilder();
    dataSource = TaskRemoteDataSourceImpl(mockSupabaseClient);
  });

  final tTaskMap = {
    'id': '1',
    'title': 'Task 1',
    'description': 'Desc',
    'status': 'todo',
    'user_id': 'user123',
  };
  final tTask = Task.fromJson(tTaskMap);

  group('getTasks', () {
    test('should return list of tasks', () async {
      when(() => mockSupabaseClient.from(any())).thenAnswer((_) => mockQueryBuilder);
      when(() => mockQueryBuilder.select()).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.order(any(), ascending: any(named: 'ascending')))
          .thenAnswer((_) => FakePostgrestTransformBuilder([tTaskMap]));

      final result = await dataSource.getTasks();

      expect(result.length, 1);
      expect(result.first.id, '1');
    });
  });

  group('addTask', () {
    test('should insert and return task', () async {
      when(() => mockSupabaseClient.from(any())).thenAnswer((_) => mockQueryBuilder);
      when(() => mockQueryBuilder.insert(any())).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.select()).thenAnswer((_) => mockTransformBuilder);
      when(() => mockTransformBuilder.single()).thenAnswer((_) => FakePostgrestTransformBuilder(tTaskMap));

      final result = await dataSource.addTask(tTask, 'user123');

      expect(result.id, '1');
      verify(() => mockQueryBuilder.insert(any())).called(1);
    });
  });

  group('deleteTask', () {
    test('should delete task', () async {
      when(() => mockSupabaseClient.from(any())).thenAnswer((_) => mockQueryBuilder);
      when(() => mockQueryBuilder.delete()).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.eq(any(), any())).thenAnswer((_) => FakePostgrestBuilder([]));

      await dataSource.deleteTask('1');

      verify(() => mockQueryBuilder.delete()).called(1);
    });
  });
}
