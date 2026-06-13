import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TableFetchError extends StatelessWidget {
  final Error? error;
  final String title;
  const TableFetchError(this.error, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    print(error?.stackTrace);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        borderRadius: .circular(10),
        border: .all(color: theme.colorScheme.border),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          spacing: 10,
          children: [
            Icon(
              Icons.warning,
              color: theme.brightness == Brightness.light
                  ? Colors.red
                  : Colors.red.shade400,
              size: 40,
            ),

            Text(title, style: theme.textTheme.h3),

            Text(
              error?.toString() ?? 'Error desconocido',
              style: theme.textTheme.p,
            ),
          ],
        ),
      ),
    );
  }
}
