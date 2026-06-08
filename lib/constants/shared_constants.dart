import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sistema_escolar_bnl/core/utils/validators.dart';

const TextStyle tabularNums = .new(fontFeatures: [.tabularFigures()]);

const kNameMinLength = 3;
const kNameMaxLength = 64;

final nameValidator = FormBuilderValidators.compose([
  Validators.required,
  FormBuilderValidators.match(
    RegExp(r'^[a-zA-Z\u00C0-\u017F\s]+$'),
    errorText: 'Solo se aceptan letras y espacios',
  ),
  Validators.minLength(kNameMinLength),
  Validators.maxLength(kNameMaxLength),
]);
