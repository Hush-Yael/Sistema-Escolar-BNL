import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/constants/shared_constants.dart';
import 'package:sistema_escolar_bnl/core/theme/theme.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/field_with_custom_validation.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/password_field.dart';
import 'package:sistema_escolar_bnl/view_models/auth/auth_vm.dart';

class FormFields extends HookWidget {
  const FormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthVm vm = AuthVm.instance.of(context);

    void submit([_]) => vm.submit(context);
    final labelStyles = AppTheme.labelStyles(context);

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

                ShadInputFormField(
                  id: AuthFormFields.name.name,
                  label: Text('Nombre personal', style: labelStyles),
                  onSubmitted: submit,
                  autovalidateMode: .onUnfocus,
                  enabled: vm.enabled,
                  validator: nameValidator,
                ),
              ],
            );
          },
        ),

        FieldWithCustomValidation<String>(
          getFieldState: () => vm.username,
          validate: AuthValidators.username,
          validateAsync: vm.checkUsername,
          builder: (onChanged, validator) {
            return ShadInputFormField(
              id: AuthFormFields.username.name,
              label: Text('Nombre de usuario', style: labelStyles),
              enabled: vm.enabled,
              onSubmitted: submit,
              validator: validator,
              onChanged: onChanged,
            );
          },
        ),

        FieldWithCustomValidation<String>(
          getFieldState: () => vm.password,
          validate: AuthValidators.password,
          builder: (onChanged, validator) {
            return PasswordField(
              id: AuthFormFields.password.name,
              label: 'Contraseña',
              enabled: vm.enabled,
              onSubmitted: submit,
              validator: validator,
              onChanged: onChanged,
            );
          },
        ),
      ],
    );
  }
}
