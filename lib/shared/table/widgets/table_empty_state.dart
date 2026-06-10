import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TableEmptyState extends StatelessWidget {
  const TableEmptyState({
    super.key,
    required this.pluralModelName,
    required this.onGoToAdd,
  });

  final String pluralModelName;
  final Widget Function()? onGoToAdd;

  @override
  Widget build(BuildContext context) {
    var colors = ShadTheme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        border: Border.all(color: colors.border),
        borderRadius: const .all(.circular(8)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            const Icon(LucideIcons.sheet, size: 40),

            const SizedBox(height: 10),

            const Text(
              'No hay nada para mostrar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 4),

            Text(
              'Parece que no se han añadido $pluralModelName',
              style: TextStyle(
                color: ShadTheme.of(context).colorScheme.mutedForeground,
              ),
            ),

            const SizedBox(height: 20),

            if (onGoToAdd != null) onGoToAdd!(),
          ],
        ),
      ),
    );
  }
}
