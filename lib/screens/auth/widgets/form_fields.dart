import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/constants/shared_constants.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/field_with_custom_validation.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/password_field.dart';
import 'package:sistema_escolar_bnl/view_models/auth/auth_vm.dart';

class FormFields extends HookWidget {
  const FormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthVm vm = AuthVm.instance.of(context);

    return Column(
      crossAxisAlignment: .stretch,
      spacing: 24,
      children: [
        Show(
          when: () => !vm.isSignIn.value,
          builder: (context) {
            return Column(
              children: [
                const SizedBox(height: 24),

                FieldWithCustomValidation.text(
                  .new(
                    id: AuthFormFields.name,
                    validate: nameValidator,
                    vm: vm,
                    label: 'Nombre personal',
                  ),
                ),
              ],
            );
          },
        ),

        FieldWithCustomValidation.text(
          .new(
            validate: AuthValidators.username,
            validateAsync: vm.checkUsername,
            id: AuthFormFields.username,
            vm: vm,
            label: 'Nombre de usuario',
          ),
        ),

        FieldWithCustomValidation<String>(
          getFieldState: () => vm.password,
          validate: AuthValidators.password,
          builder: (context, onChanged, validator) {
            return PasswordField(
              id: AuthFormFields.password.name,
              label: 'Contraseña',
              enabled: vm.enabled,
              onSubmitted: (_) => vm.submit(context),
              validator: validator,
              onChanged: onChanged,
            );
          },
        ),
      ],
    );
  }
}
