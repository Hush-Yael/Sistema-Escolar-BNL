import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_escolar_bnl/screens/auth/auth_screen.dart';

enum AppRoutes<View extends StatelessWidget Function()> {
  home('/home', view: Home.new),
  auth('/auth', view: AuthScreen.new);

  const AppRoutes(this.path, {required this.view});
  final String path;
  final View view;

  GoRoute get route {
    return .new(path: path, name: name, builder: (context, state) => view());
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Home'));
  }
}
