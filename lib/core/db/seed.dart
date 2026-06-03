import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/shared/password_manager.dart';

Future<void> seed(AppDatabase db) async {
  final pm = PasswordManager();

  final salt = pm.generateSalt();

  final pass = await pm.securePassword(passwordValue: 'admin', salt: salt);

  await db
      .into(db.users)
      .insert(
        UsersCompanion.insert(
          role: UserRole.admin,
          name: 'Administrador',
          username: 'admin',
          password: base64Encode(await pass.extractBytes()),
          salt: base64Encode(salt),
          lastLogin: Value(DateTime.now()),
        ),
      );
}
