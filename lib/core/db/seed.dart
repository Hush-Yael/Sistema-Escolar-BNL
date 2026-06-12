import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/models/models_mixins.dart';
import 'package:sistema_escolar_bnl/shared/password_manager.dart';
import 'package:faker/faker.dart';

typedef R = Future<void>;

class Seeder {
  final f = Faker();
  final pm = PasswordManager();
  final AppDatabase db;

  Seeder({required this.db});

  int currentYear = DateTime.now().year;

  static Seeder? instance;

  static R seed(AppDatabase db) async {
    final seeder = Seeder.instance ?? Seeder(db: db);
    Seeder.instance ??= seeder;

    await Future.wait([
      seeder._setupUsers(),
      seeder._setupGrades(),
      seeder._setupRepresentatives(),
    ]);
  }

  R _setupUsers() async {
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
          createdAt: newDate(min: currentYear),
          lastLogin: Value(DateTime.now()),
        ),
      );

      final roles = UserRole.values;

      batch.insertAll(
        db.users,
        List.generate(
          9,
          (i) => UsersCompanion.insert(
            role: f.randomGenerator.element(roles),
            name: f.person.name(),
            username: 'Usuario ${i + 1}',
            password: 'wrong',
            salt: 'wrong',
            lastLogin: newDate(min: currentYear),
            createdAt: newDate(),
          ),
        ),
      );
    });
  }

  Value<DateTime> newDate({int? min, int? max}) =>
      Value(f.date.dateTime(minYear: min ?? 2020, maxYear: max ?? currentYear));

  R _setupGrades() async {
    await db.batch((batch) async {
      final grades = [
        GradesCompanion.insert(number: 1, name: 'Primero', shortName: '1ero'),
        GradesCompanion.insert(number: 2, name: 'Segundo', shortName: '2do'),
        GradesCompanion.insert(number: 3, name: 'Tercero', shortName: '3ro'),
        GradesCompanion.insert(number: 4, name: 'Cuarto', shortName: '4to'),
        GradesCompanion.insert(number: 5, name: 'Quinto', shortName: '5to'),
        GradesCompanion.insert(number: 6, name: 'Sexto', shortName: '6to'),
      ];

      batch.insertAll(db.grades, grades);

      for (final letter in ['A', 'B']) {
        batch.insertAll(
          db.sections,
          List.generate(
            grades.length,
            (i) => SectionsCompanion.insert(letter: letter, gradeId: i + 1),
          ),
        );
      }
    });
  }

  R _setupRepresentatives() async {
    final phonePrefixes = ['12', '16', '14', '24', '26'];

    await db.batch((batch) async {
      final people = List.generate(
        50,
        (i) => RepresentativesCompanion.insert(
          cedula: f.randomGenerator.integer(30_000_000, min: 1_000_000),
          names: f.person.name(),
          lastNames: f.person.lastName(),
          sex: f.randomGenerator.element(Sex.values),
          phone: Value(
            '04${f.randomGenerator.element(phonePrefixes)}-${f.randomGenerator.numberOfLength(7)}',
          ),
          address: Value(f.address.streetAddress()),
          createdAt: newDate(),
        ),
      );

      batch.insertAll(db.representatives, people);
    });
  }
}
