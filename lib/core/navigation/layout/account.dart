import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = AuthState.instance.of(context);
    final user = authState.user;
    final theme = ShadTheme.of(context);

    return Row(
      spacing: 8,
      children: [
        Container(
          height: 40,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.brightness == Brightness.light
                ? Colors.black.withValues(alpha: 0.075)
                : Colors.white.withValues(alpha: 0.15),
          ),
          child: Text(
            user?.name.substring(0, 1).toUpperCase() ?? 'U',
            style: .new(fontSize: 24),
          ),
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.name ?? 'Usuario desconocido',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),

            Text(
              user?.role.label ?? 'Rol desconocido',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
