import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class FieldsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const FieldsGroup({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 40,
      children: [
        Text(title, style: theme.textTheme.p),

        Expanded(
          child: Column(
            spacing: 20,
            crossAxisAlignment: .stretch,
            children: children,
          ),
        ),
      ],
    );
  }
}
