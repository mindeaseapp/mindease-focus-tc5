
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mindease_focus/features/auth/presentation/pages/register/register_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/register_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';
import 'package:mindease_focus/core/navigation/navigation_service.dart';

class MockRegisterController extends Mock implements RegisterController {}
class MockAuthController extends Mock implements AuthController {}
class MockNavigationService extends Mock implements NavigationService {}

void main() {
  late MockRegisterController mockRegisterController;
  late MockAuthController mockAuthController;

  setUp(() {
    mockRegisterController = MockRegisterController();
    mockAuthController = MockAuthController();

    // Default stubs
    when(() => mockRegisterController.isLoading).thenReturn(false);
    when(() => mockRegisterController.isFormValid).thenReturn(false);
    when(() => mockRegisterController.errorMessage).thenReturn(null);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RegisterController>.value(value: mockRegisterController),
        ChangeNotifierProvider<AuthController>.value(value: mockAuthController),
      ],
      child: MaterialApp(
        onGenerateRoute: null,
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login Page')),
          '/home': (_) => const Scaffold(body: Text('Home Page')),
        },
        home: RegisterPage(),
      ),
    );
  }

  group('RegisterPage', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('MindEase'), findsOneWidget);
      expect(find.text('Crie sua conta'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4)); // Name, Email, Pass, Confirm
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('Criar conta'), findsOneWidget);
    });

     testWidgets('calls register on submit when form is valid', (tester) async {
      when(() => mockRegisterController.isFormValid).thenReturn(true);
      when(() => mockRegisterController.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => true);

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(find.byType(TextFormField).at(1), 'test@test.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
      await tester.enterText(find.byType(TextFormField).at(3), 'Password123!');
      
      await tester.ensureVisible(find.byType(Checkbox));
      await tester.tap(find.byType(Checkbox), warnIfMissed: false);
      await tester.pump();

      await tester.ensureVisible(find.text('Criar conta'));
      await tester.tap(find.text('Criar conta'), warnIfMissed: false);
      await tester.pump();

      verify(() => mockRegisterController.register(
            name: 'Test User',
            email: 'test@test.com',
            password: 'Password123!',
          )).called(1);
    });

    testWidgets('navigates to login on success', (tester) async {
        when(() => mockRegisterController.isFormValid).thenReturn(true);
        when(() => mockRegisterController.register(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => true);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<RegisterController>.value(value: mockRegisterController),
            ],
            child: MaterialApp(
              routes: {
                '/login': (_) => const Scaffold(body: Text('Login Page')),
              },
              home: const RegisterPage(),
            ),
          )
        );

        await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
        await tester.enterText(find.byType(TextFormField).at(1), 'test@test.com');
        await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
        await tester.enterText(find.byType(TextFormField).at(3), 'Password123!');
        await tester.ensureVisible(find.byType(Checkbox));
        await tester.tap(find.byType(Checkbox), warnIfMissed: false);
        await tester.pump();

        await tester.ensureVisible(find.text('Criar conta'));
        await tester.tap(find.text('Criar conta'), warnIfMissed: false);
        await tester.pump(); // Submit
        await tester.pumpAndSettle(); // Navigation

        expect(find.text('Conta criada com sucesso!'), findsOneWidget);
        expect(find.text('Login Page'), findsOneWidget);
    });
  });
}
