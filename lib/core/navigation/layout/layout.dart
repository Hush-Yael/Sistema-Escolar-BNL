import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/navigation/layout/header.dart';
import 'package:sistema_escolar_bnl/core/navigation/layout/sidebar.dart';
import 'package:sistema_escolar_bnl/core/navigation/routes.dart';

class Layout extends StatelessWidget {
  final GoRouterState state;
  final Widget currentScreen;

  const Layout({super.key, required this.state, required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    final currentIndex = AppRoutes.values
        .byName(state.topRoute?.name ?? AppRoutes.home.name)
        .index;

    final theme = ShadTheme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Sidebar(currentIndex: currentIndex),

          Expanded(
            child: Column(
              mainAxisAlignment: .start,
              children: [
                Header(currentIndex: currentIndex),

                // main content
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: .alphaBlend(
                        isLight
                            ? Colors.black.withValues(alpha: 0.03)
                            : Colors.black.withValues(alpha: 0.3),
                        theme.colorScheme.background,
                      ),
                      border: Border(
                        top: .new(color: theme.colorScheme.border),
                      ),
                    ),
                    child: Padding(
                      padding: const .symmetric(vertical: 15, horizontal: 20),
                      child: currentScreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
