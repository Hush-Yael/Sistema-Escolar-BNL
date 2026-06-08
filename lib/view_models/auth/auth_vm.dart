import 'dart:convert';
import 'package:disco/disco.dart';
import 'package:flutter/widgets.dart';
import 'package:sistema_escolar_bnl/repositories/auth_repo.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/shared/form_with_async_validation.dart';
import 'package:sistema_escolar_bnl/shared/password_manager.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/field_with_custom_validation.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';

class AuthVm extends FormWithAsyncValidation {
  final AuthRepository repository;
  final BuildContext context;
  final authState = AuthState.instance;

  AuthVm({required this.context, required this.repository});

  static final instance = Provider((ctx) {
    final db = AppDatabase.instance.of(ctx);
    final repository = AuthRepository(db);

    return AuthVm(context: ctx, repository: repository);
  });

  FieldState get username => getFieldState(AuthFormFields.username);
  FieldState get name => getFieldState(AuthFormFields.name);
  FieldState get password => getFieldState(AuthFormFields.password);

  final usernameTakenMsg = 'El usuario ya existe';
  final userNotFoundMsg = 'El usuario no existe';

  final passwordManager = PasswordManager();

  final isSignIn = Signal(true);

  void toggleIsSignIn() {
    if (isSubmitting.value) return;

    isSignIn.value = !isSignIn.value;
    formKey.currentState?.reset();
  }

  Future submit(BuildContext context) async {
    if (isSubmitting.value || invalid) return;

    isSubmitting.value = true;

    final User? existingUser = await delay(
      repository.getExistingUser(username!.value),
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

    await repository.updateCurrentUserLastLogin(existingUser.id);

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

    final User newUser = await repository.signupNewUser(
      name: name!.value,
      username: username!.value,
      password: base64Encode(await secretPass.extractBytes()),
      salt: base64Encode(newSalt),
    );

    authState.setUser(newUser);

    return true;
  }

  AsyncValidatorResult checkUsername(String value) async {
    final User? existingUser = await repository.getExistingUser(value);

    final exists = existingUser != null;

    if (!exists && isSignIn.value) return userNotFoundMsg;

    if (exists && !isSignIn.value) return usernameTakenMsg;

    return null;
  }

  // not needed
  @override
  Future<bool> checkAsyncErrorsBeforeSubmit() => throw UnimplementedError();

  // not needed
  @override
  Object? getFormData() => throw UnimplementedError();
}
