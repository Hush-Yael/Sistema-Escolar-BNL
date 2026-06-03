import 'dart:convert';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/field_with_custom_validation.dart';
import 'package:sistema_escolar_bnl/view_models/auth/auth_vm.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';

typedef Field =
    ShadFormBuilderFieldState<ShadFormBuilderField<dynamic>, dynamic>?;

mixin FormMixin on AuthBaseVm {
  Field get username =>
      formKey.currentState!.fields[AuthFormFields.username.name];
  Field get name => formKey.currentState!.fields[AuthFormFields.name.name];
  Field get password =>
      formKey.currentState!.fields[AuthFormFields.password.name];

  final usernameTakenMsg = 'El usuario ya existe';
  final userNotFoundMsg = 'El usuario no existe';

  @override
  Future submit(context) async {
    if (isSubmitting.value || invalid) return;

    isSubmitting.value = true;

    final User? existingUser = await delay(
      service.getExistingUser(username!.value),
      const Duration(milliseconds: 250),
    );

    final bool fine = await delay(
      (isSignIn.value ? signIn(existingUser) : signUp(existingUser))
          .whenComplete(() => isSubmitting.value = false),
      const .new(milliseconds: 250),
    );

    if (fine && context.mounted) {
      toast(
        context: context,
        message: isSignIn.value ? 'Bienvenido' : 'Cuenta creada',
      );
    }
  }

  Future<bool> signIn(User? existingUser) async {
    if (existingUser == null) {
      username!.setError(userNotFoundMsg);
      return false;
    }

    final passwordValid = await passwordManager.compare(
      passwordToCompare: password!.value,
      hashedPassword: existingUser.password,
      encodedSalt: existingUser.salt,
    );

    if (!passwordValid) {
      password!.setError('La contraseña es incorrecta');
      return false;
    }

    await service.updateCurrentUserLastLogin(existingUser.id);

    authState.setUser(existingUser);

    return true;
  }

  Future<bool> signUp(User? existingUser) async {
    if (existingUser != null) {
      username!.setError(usernameTakenMsg);
      return false;
    }

    final newSalt = passwordManager.generateSalt();

    final secretPass = await passwordManager.securePassword(
      passwordValue: password!.value,
      salt: newSalt,
    );

    final User newUser = await service.signupNewUser(
      name: name!.value,
      username: username!.value,
      password: base64Encode(await secretPass.extractBytes()),
      salt: base64Encode(newSalt),
    );

    authState.setUser(newUser);

    return true;
  }

  AsyncValidatorResult checkUsername(String value) async {
    final User? existingUser = await service.getExistingUser(value);

    final exists = existingUser != null;

    if (!exists && isSignIn.value) return userNotFoundMsg;

    if (exists && !isSignIn.value) return usernameTakenMsg;

    return null;
  }
}
