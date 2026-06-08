import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sistema_escolar_bnl/core/utils/validators.dart';
import 'package:sistema_escolar_bnl/models/models_mixins.dart';

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

final cedulaValidator = FormBuilderValidators.compose([
  Validators.required,
  FormBuilderValidators.match(
    RegExp(r'^[1-9]\d*$'),
    errorText: 'Solo se aceptan números y no puede empezar por 0',
  ),
  Validators.minLength(1),
  Validators.maxLength(10),
]);

String? sexValidator(Sex? s) => Validators.required(s!.name);
