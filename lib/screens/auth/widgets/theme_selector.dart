import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/theme/theme_mode.dart';

class AuthThemeSelector extends StatelessWidget {
  const AuthThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeModeState themeModeState = ThemeModeState.instance.of(context);

    return Positioned(
      top: 15,
      right: 15,
      child: ShadIconButton.outline(
        icon: Icon(themeModeState.state.value.icon),
        height: 30,
        width: 30,
        iconSize: 19,
        onPressed: () {
          final currentIndex = ThemeMode.values.indexOf(
            themeModeState.state.value,
          );

          final nextIndex = (currentIndex + 1) % ThemeMode.values.length;
          final nextTheme = ThemeMode.values[nextIndex];

          themeModeState.setTheme(nextTheme);
        },
      ),
    );
  }
}
