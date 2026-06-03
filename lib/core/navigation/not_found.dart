import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/navigation/routes.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          spacing: 20,
          children: [
            Column(
              spacing: 8,
              children: [
                Row(
                  mainAxisSize: .min,
                  spacing: 16,
                  children: [
                    Text(
                      '404',
                      style: ShadTheme.of(
                        context,
                      ).textTheme.h1.copyWith(fontWeight: FontWeight.w400),
                    ),

                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: ShadTheme.of(
                          context,
                        ).colorScheme.mutedForeground,
                      ),
                      child: const SizedBox(width: 1, height: 25),
                    ),
                    Text(
                      'Ruta no encontrada',
                      style: ShadTheme.of(
                        context,
                      ).textTheme.h1.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),

                Text(
                  'Parece que la ruta que buscas no existe',
                  style: ShadTheme.of(context).textTheme.h4.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ShadTheme.of(context).colorScheme.mutedForeground,
                  ),
                ),
              ],
            ),

            ShadButton(
              child: const Text('Ir al inicio'),
              onPressed: () => context.go(AppRoutes.home.path),
            ),
          ],
        ),
      ),
    );
  }
}
