
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mindease_focus/features/auth/presentation/pages/login/login_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/login_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/core/navigation/navigation_service.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';

class MockLoginController extends Mock implements LoginController {}
class MockAuthController extends Mock implements AuthController {}
class MockNavigationService extends Mock implements NavigationService {}

void main() {
  late MockLoginController mockLoginController;
  late MockAuthController mockAuthController;
  late MockNavigationService mockNavigationService;

  setUp(() {
    mockLoginController = MockLoginController();
    mockAuthController = MockAuthController();
    mockNavigationService = MockNavigationService();

    when(() => mockLoginController.isLoading).thenReturn(false);
    when(() => mockLoginController.isFormValid).thenReturn(false);
    when(() => mockLoginController.errorMessage).thenReturn(null);
    when(() => mockAuthController.user).thenReturn(UserEntity.empty());
    when(() => mockNavigationService.navigateTo(any())).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginController>.value(value: mockLoginController),
        ChangeNotifierProvider<AuthController>.value(value: mockAuthController),
        Provider<NavigationService>.value(value: mockNavigationService),
      ],
      child: const MaterialApp(
        home: LoginPage(),
      ),
    );
  }

  group('LoginPage', () {
    testWidgets('renders correctly', (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('MindEase'), findsOneWidget);
      expect(find.text('Bem-vindo de volta'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); 
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('shows loading indicator when controller is loading', (tester) async {
      when(() => mockLoginController.isLoading).thenReturn(true);
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Entrar'), findsNothing); 
    });

    testWidgets('calls login on submit when form is valid', (tester) async {
      when(() => mockLoginController.isFormValid).thenReturn(true);
      when(() => mockLoginController.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.enterText(find.byType(TextFormField).at(0), 'test@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'Password123!');
      await tester.pump();

      await tester.tap(find.text('Entrar'));
      await tester.pump();

      verify(() => mockLoginController.login(email: 'test@test.com', password: 'Password123!')).called(1);
    });

    testWidgets('navigates to dashboard on success', (tester) async {
        when(() => mockLoginController.isFormValid).thenReturn(true);
        when(() => mockLoginController.login(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => true);

        await tester.pumpWidget(createWidgetUnderTest());

        await tester.enterText(find.byType(TextFormField).at(0), 'test@test.com');
        await tester.enterText(find.byType(TextFormField).at(1), 'Password123!');
        await tester.tap(find.text('Entrar'));
        await tester.pump();

        verify(() => mockNavigationService.goToDashboard()).called(1);
    });
    
    testWidgets('shows error snackbar on failure', (tester) async {
        when(() => mockLoginController.isFormValid).thenReturn(true);
        when(() => mockLoginController.errorMessage).thenReturn('Login failed');
        when(() => mockLoginController.login(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => false);

        await tester.pumpWidget(createWidgetUnderTest());

        await tester.enterText(find.byType(TextFormField).at(0), 'test@test.com');
        await tester.enterText(find.byType(TextFormField).at(1), 'Password123!');
        await tester.tap(find.text('Entrar'));
        await tester.pump(); 
        await tester.pump();

        expect(find.text('Login failed'), findsOneWidget);
    });

    testWidgets('navigates to register page', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.tap(find.text('Cadastre-se'));
      
      verify(() => mockNavigationService.navigateTo('/register')).called(1);
    });
  });
}
