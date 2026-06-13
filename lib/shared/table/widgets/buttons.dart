import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_delete.dart';
import 'package:trina_grid/trina_grid.dart';

class SeeBtn extends StatelessWidget {
  final void Function()? onPressed;

  const SeeBtn({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 32,
      child: ShadIconButton.outline(
        icon: const Icon(Icons.visibility, size: 16),
        onPressed: onPressed,
      ),
    );
  }
}

class DeleteBtn extends StatelessWidget {
  final TrinaColumnRendererContext ctx;
  final String title;
  final SingleDeleteMutation deleteMutation;

  const DeleteBtn({
    super.key,
    required this.deleteMutation,
    required this.ctx,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ShadIconButton.destructive(
      height: 30,
      width: 30,
      iconSize: 20,
      onPressed: () {
        confirmDeletion(
          context,
          title: title,
          msg: 'Esta acción no se puede deshacer.',
          onConfirmed: () => deleteMutation.mutate(ctx),
        );
      },
      icon: const Icon(Icons.delete_outline_outlined),
    );
  }
}
