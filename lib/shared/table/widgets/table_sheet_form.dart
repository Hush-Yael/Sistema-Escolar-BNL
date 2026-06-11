import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/shared/form_with_async_validation.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/submit_btn.dart';

class TableSheetForm extends HookWidget {
  final String title;
  final Widget child;
  final ModalFormWithAsyncValidation vm;

  const TableSheetForm({
    super.key,
    required this.child,
    required this.title,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    vm.useSignalsDispose();

    vm.ensureMutationIsSet(context);

    return ShadButton(
      size: .sm,
      leading: const Icon(LucideIcons.plus),
      child: const Text('Agregar'),
      onPressed: () => showShadSheet(
        side: .right,
        context: context,
        useRootNavigator: true,
        builder: (context) => ProviderScopePortal(
          mainContext: context,
          child: ShadSheet(
            gap: 20,
            constraints: const .new(maxWidth: 512),
            titlePinned: true,
            crossAxisAlignment: .stretch,
            title: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ShadTheme.of(context).colorScheme.border,
                  ),
                ),
              ),
              padding: const .only(bottom: 6),
              child: Text(title),
            ),
            actions: [SubmitBtn(form: vm, text: 'Agregar', width: 150)],
            child: child,
          ),
        ),
      ),
    );
  }
}
