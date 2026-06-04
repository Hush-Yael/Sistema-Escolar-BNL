import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/navigation/layout/header.dart';
import 'package:sistema_escolar_bnl/core/navigation/layout/sidebar.dart';

class Layout extends StatelessWidget {
  final GoRouterState state;
  final StatefulNavigationShell navigationShell;

  const Layout({super.key, required this.state, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final Color bg = Color.alphaBlend(
      isLight
          ? Colors.black.withValues(alpha: 0.03)
          : Colors.black.withValues(alpha: 0.2),
      theme.colorScheme.background,
    );

    return Scaffold(
      backgroundColor: bg,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Sidebar(navigationShell: navigationShell, background: bg),

          Expanded(
            child: Column(
              mainAxisAlignment: .start,
              children: [
                Header(
                  currentIndex: navigationShell.currentIndex,
                  background: bg,
                ),

                // main content
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: ShadTheme.of(context).colorScheme.background,
                      borderRadius: .only(topLeft: .circular(8)),
                      border: !isLight
                          ? Border.all(
                              color: Colors.white.withValues(alpha: 0.05),
                            )
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Scaffold(body: navigationShell),
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
