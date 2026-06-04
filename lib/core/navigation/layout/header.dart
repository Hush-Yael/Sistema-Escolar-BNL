import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/navigation/layout/account.dart';
import 'package:sistema_escolar_bnl/core/navigation/layout/theme_selector.dart';
import 'package:sistema_escolar_bnl/core/navigation/routes.dart';

class Header extends StatelessWidget {
  final Color background;

  const Header({
    super.key,
    required this.currentIndex,
    required this.background,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: background),
      constraints: const BoxConstraints(maxHeight: 100),
      child: Padding(
        padding: const .all(8),
        child: Row(
          spacing: 26,
          children: [
            Text(
              AppRoutes.values[currentIndex].label,
              style: ShadTheme.of(context).textTheme.h3,
            ),

            const Spacer(),

            Row(
              spacing: 4,
              mainAxisSize: .min,
              children: [
                const ThemeSelector(),

                SizedBox(height: 20, child: const ShadSeparator.vertical()),

                const Account(),
              ],
            ),

            Row(
              spacing: 10,
              mainAxisSize: .min,
              children: [
                ShadIconButton.ghost(
                  width: 30,
                  height: 30,
                  iconSize: 16,
                  icon: const Icon(LucideIcons.settings),
                  onPressed: () {
                    GoRouter.of(context).goNamed(AppRoutes.account.name);
                  },
                ),

                ShadIconButton.ghost(
                  width: 30,
                  height: 30,
                  iconSize: 16,
                  onPressed: AuthState.instance.clearUser,
                  icon: const Icon(LucideIcons.logOut),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
