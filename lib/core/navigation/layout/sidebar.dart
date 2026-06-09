import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/navigation/layout/layout.dart';
import 'package:sistema_escolar_bnl/core/navigation/routes.dart';
import 'package:sistema_escolar_bnl/core/navigation/layout/sidebar_link.dart';
import 'package:sistema_escolar_bnl/core/shared_prefs_service.dart';

class Sidebar extends HookWidget {
  final int currentIndex;
  const Sidebar({super.key, required this.currentIndex});

  static final provider = Provider.withArgument((
    context,
    (bool isExpanded, int currentIndex, AnimationController controller) p,
  ) {
    final (isExpanded, currentIndex, controller) = p;

    final expanded = Signal(isExpanded);

    return (expanded, currentIndex, controller);
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = SharedPrefsService.instance
        .of(context)
        .getSidebarExpanded();

    final controller = useAnimationController(
      duration: const .new(milliseconds: 300),
      initialValue: isExpanded ? 1.0 : 0.0,
    );

    final animation = Tween<double>(begin: 64, end: 250).animate(controller);

    return ProviderScope(
      providers: [provider((isExpanded, currentIndex, controller))],
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) =>
            SizedBox(width: animation.value, child: child),
        child: const _Sidebar(),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    final (expanded, currentIndex, controller) = Sidebar.provider.of(context);
    final theme = ShadTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: theme.colorScheme.border)),
      ),
      child: Column(
        children: [
          _Header(),

          const ShadSeparator.horizontal(margin: .all(0)),

          Padding(
            padding: const .symmetric(vertical: 12, horizontal: 6),
            child: Column(
              crossAxisAlignment: .center,
              mainAxisSize: .min,
              spacing: 8,
              children: AppRoutes.values
                  .where((route) => route.shownInSidebar)
                  .map(
                    (route) =>
                        SidebarLink(route: route, currentIndex: currentIndex),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final prefs = SharedPrefsService.instance.of(context);
    final (expanded, _, controller) = Sidebar.provider.of(context);

    return SignalBuilder(
      builder: (context, btn) => SizedBox(
        height: Layout.headerHeight,
        child: Padding(
          padding: expanded.value
              ? .directional(
                  top: Layout.headerPy,
                  bottom: Layout.headerPy,
                  start: 16,
                  end: 4,
                )
              : .all(4),
          child: expanded.value
              ? Row(
                  crossAxisAlignment: .center,
                  mainAxisAlignment: expanded.value ? .spaceBetween : .center,
                  children: [
                    Text('Navegación', style: theme.textTheme.h4),

                    btn!,
                  ],
                )
              : Center(child: btn!),
        ),
      ),
      child: ShadIconButton.ghost(
        iconSize: 18,
        icon: Icon(
          expanded.value
              ? LucideIcons.panelLeftClose
              : LucideIcons.panelLeftOpen,
        ),
        onPressed: () {
          controller.isCompleted ? controller.reverse() : controller.forward();

          expanded.value = !expanded.value;

          prefs.saveSidebarExpanded(expanded.value);
        },
      ),
    );
  }
}
