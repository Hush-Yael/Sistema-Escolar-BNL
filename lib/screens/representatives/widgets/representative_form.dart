import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/constants/representative_constants.dart';
import 'package:sistema_escolar_bnl/constants/shared_constants.dart';
import 'package:sistema_escolar_bnl/models/models_mixins.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table_sheet_form.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/field_with_custom_validation.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/fields_group.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/label.dart';
import 'package:sistema_escolar_bnl/view_models/representative_form_vm.dart';

class RepresentativeForm extends HookWidget {
  const RepresentativeForm({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = RepresentativeFormVm.instance.of(context);

    return TableSheetForm(
      vm: vm,
      title: 'Agregar representante',
      child: ShadForm(
        key: vm.formKey,
        initialValue: {
          RepresentativeFormFields.sex.name: Sex.m,
          /* RepresentativeFormFields.cedula.name: '12',
          RepresentativeFormFields.names.name: 'John',
          RepresentativeFormFields.lastNames.name: 'Doe',
          RepresentativeFormFields.phone.name: '1234567890',
          RepresentativeFormFields.address.name: '123 Main St', */
        },
        child: Column(
          spacing: 50,
          crossAxisAlignment: .start,
          children: [
            FieldsGroup(
              title: 'Datos personales',
              children: [
                FieldWithCustomValidation.text(
                  .new(
                    label: 'Cédula',
                    id: RepresentativeFormFields.cedula,
                    validate: cedulaValidator,
                    validateAsync: vm.checkCedulaExists,
                    vm: vm,
                    keyboardType: .number,
                  ),
                ),

                FieldWithCustomValidation.text(
                  .new(
                    label: 'Nombres',
                    id: RepresentativeFormFields.names,
                    validate: nameValidator,
                    vm: vm,
                    keyboardType: TextInputType.name,
                  ),
                ),

                FieldWithCustomValidation.text(
                  .new(
                    label: 'Apellidos',
                    id: RepresentativeFormFields.lastNames,
                    validate: nameValidator,
                    vm: vm,
                    keyboardType: TextInputType.name,
                  ),
                ),

                ShadSelectFormField<Sex>(
                  initialValue: Sex.m,
                  validator: sexValidator,
                  id: RepresentativeFormFields.sex.name,
                  label: const Label('Sexo'),
                  options: Sex.values
                      .map(
                        (sex) => ShadOption(value: sex, child: Text(sex.label)),
                      )
                      .toList(),
                  selectedOptionBuilder: (context, option) =>
                      Text(option.label),
                ),
              ],
            ),

            FieldsGroup(
              title: 'Datos de contacto',
              children: [
                FieldWithCustomValidation.text(
                  .new(
                    label: 'Teléfono',
                    id: RepresentativeFormFields.phone,
                    validate: RepresentativeValidators.phone,
                    vm: vm,
                    keyboardType: TextInputType.phone,
                  ),
                ),

                FieldWithCustomValidation.textarea(
                  .new(
                    label: 'Dirección',
                    id: RepresentativeFormFields.address,
                    validate: RepresentativeValidators.address,
                    vm: vm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
