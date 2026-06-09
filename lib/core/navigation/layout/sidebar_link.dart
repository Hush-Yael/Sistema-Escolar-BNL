import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/navigation/layout/sidebar.dart';
import 'package:sistema_escolar_bnl/core/navigation/routes.dart';

class SidebarLink extends StatefulWidget {
  final int currentIndex;
  final AppRoutes<StatelessWidget Function()> route;

  const SidebarLink({
    super.key,
    required this.route,
    required this.currentIndex,
  });

  @override
  State<SidebarLink> createState() => _SidebarLinkState();
}

class _SidebarLinkState extends State<SidebarLink> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool get current =>
      widget.currentIndex == AppRoutes.values.indexOf(widget.route);

  @override
  Widget build(BuildContext context) {
    final (expanded, _, _) = Sidebar.provider.of(context);
    final colors = ShadTheme.of(context).colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SignalBuilder(
        builder: (context, child) {
          return !expanded.value
              ? ShadTooltip(
                  decoration: .new(
                    color: colors.background,
                    border: ShadBorder.all(color: colors.border, width: 1),
                  ),
                  anchor: ShadAnchor(
                    offset: const .new(4, -16),
                    overlayAlignment: .centerRight,
                  ),
                  builder: (context) => Text(
                    widget.route.label,
                    style: .new(color: colors.foreground),
                  ),
                  child: child!,
                )
              : child!;
        },
        child: ShadGestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () {
            GoRouter.of(context).go(widget.route.path);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12.0),
            decoration: BoxDecoration(
              color: resolveColor(colors),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Show(
              when: () => expanded.value,
              fallback: (context) => Icon(
                widget.route.icon,
                color: resolveForeground(colors),
                size: 20,
              ),
              builder: (context) => Row(
                spacing: 10,
                children: [
                  Icon(
                    widget.route.icon,
                    color: resolveForeground(colors),
                    size: 20,
                  ),

                  Text(
                    widget.route.label,
                    style: TextStyle(
                      color: resolveForeground(colors),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color? resolveForeground(ShadColorScheme colors) =>
      current ? colors.primaryForeground : colors.mutedForeground;

  Color resolveColor(ShadColorScheme colors) {
    if (current) {
      if (_isPressed) {
        return colors.primary.withValues(alpha: 0.7);
      } else if (_isHovered) {
        return colors.primary.withValues(alpha: 0.8);
      }
      return colors.primary;
    }

    if (_isPressed) {
      return colors.primary.withValues(alpha: 0.15);
    } else if (_isHovered) {
      return colors.primary.withValues(alpha: 0.075);
    } else {
      return Colors.transparent;
    }
  }
}
