import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SubmitBtnRing extends StatelessWidget {
  final double size;
  const SubmitBtnRing({super.key, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: ShadTheme.of(context).colorScheme.primaryForeground,
      ),
    );
  }
}
