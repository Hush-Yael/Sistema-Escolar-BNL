import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/navigation/routes.dart';
import 'package:sistema_escolar_bnl/core/navigation/layout/sidebar_link.dart';

class Sidebar extends StatelessWidget {
  final int currentIndex;
  const Sidebar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        border: Border(
          right: .new(color: ShadTheme.of(context).colorScheme.border),
        ),
      ),
      padding: const .all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: AppRoutes.values
            .where((route) => route.shownInSidebar)
            .map(
              (route) => SidebarLink(route: route, currentIndex: currentIndex),
            )
            .toList(),
      ),
    );
  }
}
