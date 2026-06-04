import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/navigation/routes.dart';

class SidebarLink extends StatefulWidget {
  final AppRoutes<StatelessWidget Function()> route;
  final bool current;
  const SidebarLink({super.key, required this.route, required this.current});

  @override
  State<SidebarLink> createState() => _SidebarLinkState();
}

class _SidebarLinkState extends State<SidebarLink> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
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
            color: resolveColor(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.route.label,
            style: TextStyle(
              color: resolveForeground(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Color? resolveForeground() {
    final theme = ShadTheme.of(context);

    return widget.current
        ? theme.colorScheme.primaryForeground
        : theme.colorScheme.mutedForeground;
  }

  Color resolveColor() {
    final theme = ShadTheme.of(context);

    if (widget.current) {
      if (_isPressed) {
        return theme.colorScheme.primary.withValues(alpha: 0.7);
      } else if (_isHovered) {
        return theme.colorScheme.primary.withValues(alpha: 0.8);
      }
      return theme.colorScheme.primary;
    }

    if (_isPressed) {
      return theme.colorScheme.primary.withValues(alpha: 0.2);
    } else if (_isHovered) {
      return theme.colorScheme.primary.withValues(alpha: 0.1);
    } else {
      return Colors.transparent;
    }
  }
}
