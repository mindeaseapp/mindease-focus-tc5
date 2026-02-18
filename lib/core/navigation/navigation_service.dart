import 'package:flutter/material.dart';
import 'package:mindease_focus/core/navigation/routes.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> replaceWith(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }

  void goToLogin() => replaceWith(AppRoutes.login);
  void goToDashboard() => replaceWith(AppRoutes.dashboard);
  void goToTasks({int? tabIndex}) => navigateTo(AppRoutes.tasks, arguments: tabIndex);
  void goToProfile() => navigateTo(AppRoutes.profile);
}
