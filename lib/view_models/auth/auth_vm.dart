import 'package:disco/disco.dart';
import 'package:flutter/widgets.dart';
import 'package:sistema_escolar_bnl/repositories/auth_repo.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:sistema_escolar_bnl/view_models/auth/auth_vm_form_mixin.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/shared/form_with_async_validation.dart';
import 'package:sistema_escolar_bnl/shared/password_manager.dart';

class AuthBaseVm extends FormWithAsyncValidation {
  final AuthRepository repository;
  final BuildContext context;
  final authState = AuthState.instance;

  AuthBaseVm({required this.context, required this.repository});

  final passwordManager = PasswordManager();

  final isSignIn = Signal(true);

  void toggleIsSignIn() {
    if (isSubmitting.value) return;

    isSignIn.value = !isSignIn.value;
    formKey.currentState?.reset();
  }
}

class AuthVm extends AuthBaseVm with FormMixin {
  AuthVm({required super.context, required super.repository});

  static final instance = Provider((ctx) {
    final db = AppDatabase.instance.of(ctx);
    final repository = AuthRepository(db);

    return AuthVm(context: ctx, repository: repository);
  });
}
