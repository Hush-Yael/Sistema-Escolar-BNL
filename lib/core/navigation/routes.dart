import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_escolar_bnl/screens/users_screen.dart';

enum AppRoutes<View extends StatelessWidget Function()> {
  home('/home', label: 'Inicio'),

  users('/users', label: 'Usuarios', view: UsersScreen.new),

  representantes('/representantes', label: 'Representantes'),

  students('/students', label: 'Estudiantes'),

  grados('/grados', label: 'Grados'),

  sections('/sections', label: 'Secciones'),

  account('/account', label: 'Cuenta', shownInSidebar: false);

  const AppRoutes(
    this.path, {
    this.view,
    required this.label,
    this.shownInSidebar = true,
  });

  final String path;
  final View? view;
  final String label;
  final bool shownInSidebar;

  GoRoute get route => .new(
    path: path,
    name: name,
    pageBuilder: (context, state) =>
        NoTransitionPage(child: view?.call() ?? Text(name)),
  );
}
