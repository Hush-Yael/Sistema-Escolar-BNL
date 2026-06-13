import 'package:drift/drift.dart';
import 'package:sistema_escolar_bnl/models/models_mixins.dart';
import 'package:sistema_escolar_bnl/models/school_models.dart';

class Students extends Table with Person, Timestamps {
  late final id = integer().autoIncrement()();

  late final birthDate = dateTime()();

  late final birthPlace = text()();

  late final indigenous = boolean().withDefault(const Constant(false))();

  late final disfunction = text().nullable()();

  late final hasCanaima = boolean().withDefault(const Constant(false))();
}

class Enrollments extends Table with Timestamps {
  late final id = integer().autoIncrement()();

  late final studentId = integer().references(
    Students,
    #id,
    onDelete: .cascade,
  )();

  late final sectionId = integer().references(
    Sections,
    #id,
    onDelete: .restrict,
  )();

  late final weight = real()();

  late final height = real()();

  late final shoeSize = integer()();

  late final pantSize = integer()();

  late final shirtSize = integer()();

  late final condition = textEnum<Condition>()();
}

enum Condition {
  // ignore: constant_identifier_names
  RG('Regular'),
  // ignore: constant_identifier_names
  RP('Repitiente');

  const Condition(this.label);
  final String label;
}
