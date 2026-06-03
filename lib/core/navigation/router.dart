import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/db/reset_btn.dart';
import 'package:sistema_escolar_bnl/core/navigation/not_found.dart';
import 'package:sistema_escolar_bnl/core/navigation/routes.dart';

class AppRouter {
  final AuthState authState;

  AppRouter({required this.authState});

  late final config = GoRouter(
    initialLocation: AppRoutes.home.path,
    refreshListenable: authState,
    routes: appRoutes,
    errorBuilder: (context, state) => const NotFound(),
    redirect: handleRedirect,
  );

  FutureOr<String?> handleRedirect(BuildContext context, GoRouterState state) {
    final String authPath = AppRoutes.auth.path;
    final bool isAuthenticated = authState.isAuthenticated();

    // Redirect to login if not authenticated and not already on login
    if (!isAuthenticated && !state.matchedLocation.contains(authPath)) {
      return authPath;
    }

    // Redirect to home if authenticated and on login
    if (isAuthenticated && state.matchedLocation.contains(authPath)) {
      return AppRoutes.home.path;
    }

    return null; // No redirect
  }

  final List<RouteBase> appRoutes = [
    ...AppRoutes.values.map((route) => route.route),
  ];
}

Widget routeBuilder(BuildContext context, GoRouterState? state, Widget view) =>
    kReleaseMode ? view : WithResetBtn(widget: view);
