import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/shared/password_manager.dart';
import 'package:faker/faker.dart';

Future<void> seed(AppDatabase db) async {
  final faker = Faker();
  final pm = PasswordManager();

  final salt = pm.generateSalt();

  final pass = await pm.securePassword(passwordValue: 'admin', salt: salt);

  await db.batch((batch) async {
    batch.insert(
      db.users,
      UsersCompanion.insert(
        role: UserRole.admin,
        name: 'Administrador',
        username: 'admin',
        password: base64Encode(await pass.extractBytes()),
        salt: base64Encode(salt),
        lastLogin: Value(DateTime.now()),
      ),
    );

    final roles = UserRole.values;

    batch.insertAll(
      db.users,
      List.generate(
        9,
        (i) => UsersCompanion.insert(
          role: faker.randomGenerator.element(roles),
          name: faker.person.name(),
          username: 'Usuario ${i + 1}',
          password: 'wrong',
          salt: 'wrong',
          lastLogin: Value(faker.date.dateTime()),
          createdAt: Value(faker.date.dateTime()),
        ),
      ),
    );
  });
}
