import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoutes<View extends StatelessWidget Function()> {
  home('/home', label: 'Inicio'),

  users('/users', label: 'Usuarios'),

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
    builder: (context, state) => view?.call() ?? Text(name),
  );
}
