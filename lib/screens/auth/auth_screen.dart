import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/theme/theme.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/submit_btn_ring.dart';
import 'package:sistema_escolar_bnl/view_models/auth/auth_vm.dart';
import 'package:sistema_escolar_bnl/screens/auth/widgets/form_fields.dart';
import 'package:sistema_escolar_bnl/screens/auth/widgets/theme_selector.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    maxHeight: double.infinity,
                  ),
                  child: Center(
                    child: ProviderScope(
                      providers: [AuthVm.instance],
                      child: const _Form(),
                    ),
                  ),
                ),
              ),
              const AuthThemeSelector(),
            ],
          );
        },
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final vm = AuthVm.instance.of(context);
    final isSignIn = vm.isSignIn;

    return ShadForm(
      key: vm.formKey,
      child: Center(
        child: Padding(
          padding: const .all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, minHeight: 350),
            child: ShadCard(
              child: Column(
                crossAxisAlignment: .stretch,
                mainAxisAlignment: .spaceBetween,
                children: [
                  SignalBuilder(
                    builder: (context, child) => Text(
                      isSignIn.value ? 'Ingresar al sistema' : 'Crear cuenta',
                      style: context.theme.textTheme.h3,
                      textAlign: .center,
                    ),
                  ),

                  FormFields(),

                  const SizedBox(height: 24),

                  // Form buttons
                  SignalBuilder(
                    builder: (context, child) => Column(
                      crossAxisAlignment: .stretch,
                      spacing: 4,
                      children: [
                        ShadButton(
                          onPressed: () => vm.submit(context),
                          enabled: !vm.isSubmitting.value,
                          leading: vm.isSubmitting.value
                              ? const SubmitBtnRing()
                              : null,
                          child: Text(isSignIn.value ? 'Ingresar' : 'Crear'),
                        ),

                        ShadButton.link(
                          onPressed: vm.toggleIsSignIn,
                          enabled: !vm.isSubmitting.value,
                          child: Text(
                            isSignIn.value ? 'Crear cuenta' : 'Iniciar sesión',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
