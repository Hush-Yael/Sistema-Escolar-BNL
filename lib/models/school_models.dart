import 'package:drift/drift.dart';

class Grades extends Table {
  late final id = integer().autoIncrement()();

  late final number = integer().unique()();

  late final name = text().unique()();

  late final shortName = text().unique()();
}

class Sections extends Table {
  late final id = integer().autoIncrement()();

  late final letter = text().withLength(min: 1, max: 1).unique()();

  late final capacity = integer().withDefault(const Constant(30))();

  late final gradeId = integer().references(Grades, #id, onDelete: .restrict)();
}
