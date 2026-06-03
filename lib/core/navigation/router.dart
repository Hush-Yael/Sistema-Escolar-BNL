import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/db/reset_btn.dart';
import 'package:sistema_escolar_bnl/core/navigation/not_found.dart';

class AppRouter {
  final AuthState authState;

  AppRouter({required this.authState});

  static const String authPath = '/auth';

  late final config = GoRouter(
    refreshListenable: authState,
    routes: appRoutes,
    errorBuilder: (context, state) => const NotFound(),
    redirect: handleRedirect,
  );

  FutureOr<String?> handleRedirect(BuildContext context, GoRouterState state) {
    final bool isAuthenticated = authState.isAuthenticated();

    // Redirect to login if not authenticated and not already on login
    if (!isAuthenticated && !state.matchedLocation.contains(authPath)) {
      return authPath;
    }

    // Redirect to home if authenticated and on login
    if (isAuthenticated && state.matchedLocation.contains(authPath)) {
      return '/';
    }

    return null; // No redirect
  }

  final List<RouteBase> appRoutes = [];
}

Widget routeBuilder(BuildContext context, GoRouterState? state, Widget view) =>
    kReleaseMode ? view : WithResetBtn(widget: view);
