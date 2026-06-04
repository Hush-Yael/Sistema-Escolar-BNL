import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_escolar_bnl/core/navigation/routes.dart';
import 'package:sistema_escolar_bnl/core/navigation/layout/sidebar_link.dart';

class Sidebar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final Color background;

  const Sidebar({
    super.key,
    required this.navigationShell,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const .all(12),
      decoration: BoxDecoration(color: background),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: AppRoutes.values
            .where((route) => route.shownInSidebar)
            .map(
              (route) =>
                  SidebarLink(route: route, navigationShell: navigationShell),
            )
            .toList(),
      ),
    );
  }
}
