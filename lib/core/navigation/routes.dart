import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_escolar_bnl/screens/sections_screen.dart';
import 'package:sistema_escolar_bnl/screens/users_screen.dart';

enum AppRoutes<View extends StatelessWidget Function()> {
  home('/home', label: 'Inicio', icon: Icons.home),

  users('/users', label: 'Usuarios', view: UsersScreen.new, icon: Icons.groups),

  representatives(
    '/representatives',
    label: 'Representantes',
    icon: Icons.supervised_user_circle,
  ),

  students('/students', label: 'Estudiantes', icon: Icons.school),

  sections(
    '/sections',
    label: 'Secciones',
    view: SectionsScreen.new,
    icon: Icons.view_column,
  ),

  account('/account', label: 'Cuenta', shownInSidebar: false);

  const AppRoutes(
    this.path, {
    required this.label,
    this.icon,
    this.view,
    this.shownInSidebar = true,
  });

  final String path;
  final View? view;
  final String label;
  final bool shownInSidebar;
  final IconData? icon;

  GoRoute get route => .new(
    path: path,
    name: name,
    pageBuilder: (context, state) =>
        NoTransitionPage(child: view?.call() ?? Text(name)),
  );
}
