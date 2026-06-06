import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/db/reset_btn.dart';
import 'package:sistema_escolar_bnl/core/navigation/layout/layout.dart';
import 'package:sistema_escolar_bnl/core/navigation/not_found.dart';
import 'package:sistema_escolar_bnl/core/navigation/routes.dart';
import 'package:sistema_escolar_bnl/screens/auth/auth_screen.dart';

class AppRouter {
  final AuthState authState;

  AppRouter({required this.authState});

  static const String authPath = '/auth';

  static final config = GoRouter(
    initialLocation: AppRoutes.home.path,
    refreshListenable: AuthState.instance,
    routes: appRoutes,
    errorBuilder: (context, state) => const NotFound(),
    redirect: (context, state) {
      final bool isAuthenticated = AuthState.instance.isAuthenticated();

      // Redirect to login if not authenticated and not already on login
      if (!isAuthenticated && !state.matchedLocation.contains(authPath)) {
        return authPath;
      }

      // Redirect to home if authenticated and on login
      if (isAuthenticated && state.matchedLocation.contains(authPath)) {
        return AppRoutes.home.path;
      }

      return null; // No redirect
    },
  );

  static final List<RouteBase> appRoutes = [
    GoRoute(
      path: authPath,
      builder: (context, state) =>
          routeBuilder(context, state, const AuthScreen()),
    ),

    ShellRoute(
      builder: (context, state, currentScreen) {
        return routeBuilder(
          context,
          state,
          Layout(state: state, currentScreen: currentScreen),
        );
      },
      routes: AppRoutes.values.map((page) => page.route).toList(),
    ),
  ];
}

Widget routeBuilder(BuildContext context, GoRouterState? state, Widget view) =>
    kReleaseMode ? view : WithResetBtn(widget: view);
