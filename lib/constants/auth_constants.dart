import 'package:flutter/foundation.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sistema_escolar_bnl/core/utils/validators.dart';

enum UserRole {
  admin('Admin', 3),
  operator('Operador', 2),
  supervisor('Supervisor', 1);

  final String label;
  final int level;

  const UserRole(this.label, this.level);
}

enum AuthFormFields { name, username, password }

class AuthValidators {
  static final username = FormBuilderValidators.compose([
    Validators.required,
    Validators.minLength(kUsernameMinLength),
    Validators.maxLength(kUsernameMaxLength),
    FormBuilderValidators.match(
      RegExp(r'^[a-zA-Z0-9_]+$'),
      errorText:
          'El nombre de usuario solo puede contener letras, números y pisos',
    ),
  ]);

  static final password = FormBuilderValidators.compose([
    Validators.required,
    Validators.minLength(kPasswordMinLength),
    Validators.maxLength(kPasswordMaxLength),
    FormBuilderValidators.match(
      RegExp(r'^[^\s]+$'),
      errorText: 'La contraseña no puede contener espacios',
    ),
  ]);
}

const kUsernameMinLength = 3;
const kUsernameMaxLength = 64;

const kPasswordMinLength = kReleaseMode ? 6 : 3;
const kPasswordMaxLength = 128;
