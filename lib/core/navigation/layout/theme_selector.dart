import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/theme/theme_mode.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = ThemeModeState.instance.of(context);

    return SignalBuilder(
      builder: (context, child) => ShadSelect<ThemeMode>(
        initialValue: themeMode.state.value,
        onChanged: (value) => themeMode.setTheme(value!),
        selectedOptionBuilder: (context, option) => Option(option),
        options: ThemeMode.values
            .map((mode) => ShadOption(value: mode, child: Option(mode)))
            .toList(),
      ),
    );
  }
}

class Option extends StatelessWidget {
  final ThemeMode mode;
  const Option(this.mode, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(spacing: 10, children: [Icon(mode.icon), Text(mode.label)]);
  }
}
